use base64::{engine::general_purpose, Engine as _};
use std::env;
use std::error::Error;
use std::process;

fn main() -> Result<(), Box<dyn Error>> {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        eprintln!("not enough arguments");
        process::exit(1)
    }
    let base64_string = args[1].clone();
    let bytes = general_purpose::STANDARD
        .decode(base64_string)
        .unwrap_or_else(|err| {
            eprintln!("Problem decoding string from base64: {err}");
            process::exit(1)
        });
    let hex_string = hex::encode(bytes);
    println!("{}", hex_string.to_ascii_uppercase());
    Ok(())
}
