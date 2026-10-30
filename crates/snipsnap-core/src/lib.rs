use image::{Rgba, RgbaImage};
use serde::{Deserialize, Serialize};

/// Coordinates are source-image pixels, with the origin at the top left.
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct Annotation {
    pub kind: String,
    pub x1: f64,
    pub y1: f64,
    pub x2: f64,
    pub y2: f64,
    pub width: u32,
    pub color: [u8; 4],
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct Document {
    pub version: u32,
    pub annotations: Vec<Annotation>,
}

impl Document {
    pub fn render(&self, image: &mut RgbaImage) -> Result<(), String> {
        if self.version != 1 || self.annotations.len() > 10_000 {
            return Err("Unsupported document version or too many annotations".into());
        }
        for a in &self.annotations {
            let values = [a.x1, a.y1, a.x2, a.y2];
            if values.iter().any(|v| !v.is_finite() || v.abs() > 100_000.0)
                || !(1..=64).contains(&a.width)
            {
                return Err("Invalid annotation geometry".into());
            }
            match a.kind.as_str() {
                "rectangle" => {
                    line(image, a, a.x1, a.y1, a.x2, a.y1);
                    line(image, a, a.x2, a.y1, a.x2, a.y2);
                    line(image, a, a.x2, a.y2, a.x1, a.y2);
                    line(image, a, a.x1, a.y2, a.x1, a.y1);
                }
                "line" | "arrow" => {
                    line(image, a, a.x1, a.y1, a.x2, a.y2);
                    if a.kind == "arrow" {
                        let angle = (a.y2 - a.y1).atan2(a.x2 - a.x1);
                        let size = f64::from(a.width * 4 + 8);
                        for offset in [-0.5_f64, 0.5] {
                            line(
                                image,
                                a,
                                a.x2,
                                a.y2,
                                a.x2 - size * (angle + offset).cos(),
                                a.y2 - size * (angle + offset).sin(),
                            );
                        }
                    }
                }
                _ => return Err("Unknown annotation tool".into()),
            }
        }
        Ok(())
    }
}

fn line(image: &mut RgbaImage, a: &Annotation, x1: f64, y1: f64, x2: f64, y2: f64) {
    // Scan only the clipped bounding box; cost is bounded by image dimensions.
    let radius = f64::from(a.width) / 2.0;
    let left = (x1.min(x2) - radius).max(0.0) as u32;
    let top = (y1.min(y2) - radius).max(0.0) as u32;
    let right = ((x1.max(x2) + radius).ceil() as u32).min(image.width());
    let bottom = ((y1.max(y2) + radius).ceil() as u32).min(image.height());
    let dx = x2 - x1;
    let dy = y2 - y1;
    let length = dx * dx + dy * dy;
    for y in top..bottom {
        for x in left..right {
            let px = f64::from(x) + 0.5;
            let py = f64::from(y) + 0.5;
            let t = if length == 0.0 {
                0.0
            } else {
                (((px - x1) * dx + (py - y1) * dy) / length).clamp(0.0, 1.0)
            };
            if (px - x1 - t * dx).hypot(py - y1 - t * dy) <= radius {
                let dest = image.get_pixel_mut(x, y);
                let alpha = f32::from(a.color[3]) / 255.0;
                let dest_alpha = f32::from(dest[3]) / 255.0;
                let out_alpha = alpha + dest_alpha * (1.0 - alpha);
                if out_alpha > 0.0 {
                    for channel in 0..3 {
                        dest[channel] = ((f32::from(a.color[channel]) * alpha
                            + f32::from(dest[channel]) * dest_alpha * (1.0 - alpha))
                            / out_alpha)
                            .round() as u8;
                    }
                }
                dest[3] = (out_alpha * 255.0).round() as u8;
            }
        }
    }
}

pub fn load_image(path: &std::path::Path) -> Result<RgbaImage, String> {
    if std::fs::metadata(path).map_err(|e| e.to_string())?.len() > 256 * 1024 * 1024 {
        return Err("Image file exceeds 256 MiB".into());
    }
    let mut reader = image::ImageReader::open(path).map_err(|e| e.to_string())?;
    let mut limits = image::Limits::default();
    limits.max_image_width = Some(16_384);
    limits.max_image_height = Some(16_384);
    limits.max_alloc = Some(256 * 1024 * 1024);
    reader.limits(limits);
    let decoded = reader.decode().map_err(|e| e.to_string())?;
    if u64::from(decoded.width()) * u64::from(decoded.height()) > 64 * 1024 * 1024 {
        return Err("Image exceeds 64 megapixels".into());
    }
    Ok(decoded.to_rgba8())
}

/// Encode alongside the destination, then rename so failed encoding preserves an existing export.
pub fn export(
    image: RgbaImage,
    source: &std::path::Path,
    output: &std::path::Path,
) -> Result<(), String> {
    if output == source
        || (output.exists() && source.canonicalize().ok() == output.canonicalize().ok())
    {
        return Err("Export must not replace the source image".into());
    }
    let extension = output
        .extension()
        .and_then(|e| e.to_str())
        .unwrap_or("")
        .to_ascii_lowercase();
    let (image, format) = match extension.as_str() {
        "png" => (
            image::DynamicImage::ImageRgba8(image),
            image::ImageFormat::Png,
        ),
        "jpg" | "jpeg" => {
            // JPEG has no alpha: composite onto white explicitly.
            let rgb = image::RgbImage::from_fn(image.width(), image.height(), |x, y| {
                let p = image.get_pixel(x, y);
                let a = u32::from(p[3]);
                image::Rgb(std::array::from_fn(|c| {
                    ((u32::from(p[c]) * a + 255 * (255 - a) + 127) / 255) as u8
                }))
            });
            (
                image::DynamicImage::ImageRgb8(rgb),
                image::ImageFormat::Jpeg,
            )
        }
        _ => return Err("Export supports PNG and JPEG".into()),
    };
    let parent = output
        .parent()
        .filter(|p| !p.as_os_str().is_empty())
        .unwrap_or(std::path::Path::new("."));
    let mut temporary = tempfile::NamedTempFile::new_in(parent).map_err(|e| e.to_string())?;
    image
        .write_to(temporary.as_file_mut(), format)
        .map_err(|e| e.to_string())?;
    temporary.as_file().sync_all().map_err(|e| e.to_string())?;
    temporary.persist(output).map_err(|e| e.to_string())?;
    Ok(())
}

pub fn fixture(path: &std::path::Path) -> Result<(), String> {
    let mut image = RgbaImage::from_pixel(640, 400, Rgba([245, 247, 250, 255]));
    for y in 80..320 {
        for x in 80..560 {
            image.put_pixel(x, y, Rgba([40, 110, 180, 255]));
        }
    }
    image.save(path).map_err(|e| e.to_string())
}

#[cfg(test)]
mod tests {
    use super::*;
    fn annotation() -> Annotation {
        Annotation {
            kind: "rectangle".into(),
            x1: 2.0,
            y1: 2.0,
            x2: 8.0,
            y2: 8.0,
            width: 2,
            color: [255, 0, 0, 255],
        }
    }
    #[test]
    fn renders_outline_and_preserves_source_interior() {
        let mut img = RgbaImage::from_pixel(12, 12, Rgba([255; 4]));
        Document {
            version: 1,
            annotations: vec![annotation()],
        }
        .render(&mut img)
        .unwrap();
        assert_eq!(img.get_pixel(2, 4).0, [255, 0, 0, 255]);
        assert_eq!(img.get_pixel(5, 5).0, [255; 4]);
    }
    #[test]
    fn rejects_invalid_documents_and_geometry() {
        let mut img = RgbaImage::new(4, 4);
        assert!(
            Document {
                version: 2,
                annotations: vec![]
            }
            .render(&mut img)
            .is_err()
        );
        let mut a = annotation();
        a.x1 = f64::NAN;
        assert!(
            Document {
                version: 1,
                annotations: vec![a]
            }
            .render(&mut img)
            .is_err()
        );
    }
    #[test]
    fn clips_negative_coordinates_and_handles_zero_length() {
        let mut a = annotation();
        a.kind = "arrow".into();
        a.x1 = -5.0;
        a.x2 = -5.0;
        let mut img = RgbaImage::new(4, 4);
        Document {
            version: 1,
            annotations: vec![a],
        }
        .render(&mut img)
        .unwrap();
    }

    #[test]
    fn composites_straight_alpha_on_transparent_source() {
        let mut a = annotation();
        a.kind = "line".into();
        a.color = [255, 0, 0, 128];
        let mut img = RgbaImage::new(12, 12);
        Document {
            version: 1,
            annotations: vec![a],
        }
        .render(&mut img)
        .unwrap();
        assert_eq!(img.get_pixel(5, 5).0, [255, 0, 0, 128]);
    }
}
