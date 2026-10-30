use std::{fs, process::Command};

#[test]
fn fixture_annotation_export_and_invalid_document() {
    let dir = std::env::temp_dir().join(format!("snipsnap-test-{}", std::process::id()));
    fs::create_dir_all(&dir).unwrap();
    let source = dir.join("source.png");
    let document = dir.join("edit.json");
    let output = dir.join("export.png");
    let jpeg = dir.join("export.jpg");
    let binary = env!("CARGO_BIN_EXE_snipsnap-core");
    assert!(
        Command::new(binary)
            .arg("fixture")
            .arg(&source)
            .status()
            .unwrap()
            .success()
    );
    let original = fs::read(&source).unwrap();
    fs::write(&document, r#"{"version":1,"annotations":[{"kind":"line","x1":10,"y1":10,"x2":20,"y2":10,"width":4,"color":[255,0,0,255]}]}"#).unwrap();
    for target in [&output, &jpeg] {
        assert!(
            Command::new(binary)
                .arg("render")
                .arg(&source)
                .arg(&document)
                .arg(target)
                .status()
                .unwrap()
                .success()
        );
        let rendered = image::open(target).unwrap();
        assert_eq!((rendered.width(), rendered.height()), (640, 400));
    }
    let rendered = image::open(&output).unwrap().to_rgba8();
    assert_eq!(rendered.get_pixel(15, 10).0, [255, 0, 0, 255]);
    assert_eq!(fs::read(&source).unwrap(), original);
    assert!(
        !Command::new(binary)
            .arg("render")
            .arg(&source)
            .arg(&document)
            .arg(&source)
            .status()
            .unwrap()
            .success()
    );
    fs::write(&document, r#"{"version":99,"annotations":[]}"#).unwrap();
    fs::remove_file(&output).unwrap();
    assert!(
        !Command::new(binary)
            .arg("render")
            .arg(&source)
            .arg(&document)
            .arg(&output)
            .status()
            .unwrap()
            .success()
    );
    assert!(!output.exists());
    // A corrupt source must not replace an already exported file.
    fs::write(&source, b"not an image").unwrap();
    fs::write(&output, b"keep previous export").unwrap();
    fs::write(&document, r#"{"version":1,"annotations":[]}"#).unwrap();
    assert!(
        !Command::new(binary)
            .arg("render")
            .arg(&source)
            .arg(&document)
            .arg(&output)
            .status()
            .unwrap()
            .success()
    );
    assert_eq!(fs::read(&output).unwrap(), b"keep previous export");
    fs::remove_dir_all(dir).unwrap();
}
