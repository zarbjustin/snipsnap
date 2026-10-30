use snipsnap_core::{Document, export, fixture, load_image};
use std::{
    io::Read,
    path::Path,
    process::{Command, ExitCode},
};

fn run(args: &[String]) -> Result<(), String> {
    match args.first().map(String::as_str) {
        Some("capture") if args.len() == 3 => {
            if !cfg!(target_os = "macos") { return Err("Capture requires macOS".into()); }
            let mode = match args[1].as_str() {
                "region" => vec!["-x", "-i", "-s"],
                "window" => vec!["-x", "-i", "-w", "-o"],
                "screen" => vec!["-x", "-m"],
                _ => return Err("Unknown capture mode".into()),
            };
            if Path::new(&args[2]).exists() { return Err("Capture destination already exists".into()); }
            let status = Command::new("/usr/sbin/screencapture").args(mode)
                .arg("-t").arg("png").arg(&args[2]).status().map_err(|e| e.to_string())?;
            if !status.success() || !Path::new(&args[2]).exists() {
                return Err("Capture cancelled or Screen Recording permission unavailable".into());
            }
            let img = load_image(Path::new(&args[2]))?;
            println!("{{\"width\":{},\"height\":{}}}", img.width(), img.height());
        }
        Some("render") if args.len() == 4 => {
            let mut data = Vec::new();
            std::fs::File::open(&args[2]).map_err(|e| e.to_string())?
                .take(4 * 1024 * 1024 + 1).read_to_end(&mut data).map_err(|e| e.to_string())?;
            if data.len() > 4 * 1024 * 1024 { return Err("Document too large".into()); }
            let doc: Document = serde_json::from_slice(&data).map_err(|e| e.to_string())?;
            let mut img = load_image(Path::new(&args[1]))?;
            doc.render(&mut img)?;
            export(img, Path::new(&args[1]), Path::new(&args[3]))?;
        }
        Some("fixture") if args.len() == 2 => fixture(Path::new(&args[1]))?,
        _ => return Err("Usage: snipsnap-core capture <screen|region|window> <new.png> | render <source> <document.json> <output.png|jpg> | fixture <output.png>".into()),
    }
    Ok(())
}
fn main() -> ExitCode {
    match run(&std::env::args().skip(1).collect::<Vec<_>>()) {
        Ok(()) => ExitCode::SUCCESS,
        Err(e) => {
            eprintln!("{e}");
            ExitCode::FAILURE
        }
    }
}
