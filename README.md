# BitlockerRecoveryKeyToBarcode
Generates barcodes from BitLocker Recovery Keys and display it on screen. The script is inspired by some clever guy in australia that remembered that barcode scanner are treated as any other keyboard, even before booting into OS. Read the story [here](https://www.theregister.com/2024/07/25/crowdstrike_remediation_with_barcode_scanner/)

### Font requirments
* The script needs to have the [Code39-barcodefont](https://www.dafont.com/code39.font) installed, and use the code 39 standard by default
* Other fonts can be used by specifying font name in the `useAlternativeBarcodeFont`-parameter

### Input
* Input is validated to ensure that the Bitlocker key is correctly formated
  * Example recovery key: `002130-563959-533643-315590-484044-259380-247291-123563`
* Input is accepted through GUI, parameter or pipeline

### How it looks
![Skjermbilde 2024-07-31 210421](https://github.com/user-attachments/assets/f3425823-f59f-4059-bf48-153f307c7a33)

# Tips 💡
* Scanners
  * 2D CMOS scanners are recommended. Will be the best alternative for scanning barcodes off computer screens. Due to ani-reflection coating, laser readers will not always work. CCD works under good conditions
  * To prevent  linebreak/enter/carriage return to be suffixed after each scan there is usually provided configuration barcodes that turn this off. They can be labeled "Suffix ETX" or "Disable Carriage Return"
* Hitting the "Escape" character on your keyboard will close the GUI and you will return to your shell


# Usage

### 🔵Example 1 - No parameters
This will display the GUI, and you can generate barcodes
```PowerShell
BitLockerRKToBarcode
```

### 🔵Example 2 - Input from pipeline
The function accepts a valid Bitlocker key from pipeline, automatically show GUI with the barcode already generated.
This means you can integrate it with your other scripts that are able to get a recovery key from computername, for instance.
```PowerShell
"002130-563959-533643-315590-484044-259380-247291-123563" | BitLockerRKToBarcode
```

### 🔵Example 3 - Key as parameter
This will accept a valid Bitlocker key as parameter, automatically show GUI with the barcode already generated
```PowerShell
BitLockerRKToBarcode -BitlockerRecoveryKey "002130-563959-533643-315590-484044-259380-247291-123563"
```

### 🔵Example 4 - Alternative barcode-fonts
This will use the alternative font specified to generate the barcodes, if the code 39 standard is not compatible with your scanner.
```PowerShell
BitLockerRKToBarcode -useAlternativeBarcodeFont "Libre Barcode 128"
```

### 🔵Example 5 - Encode dashes
Readers can interpert dashes (-) as plus-symbols (+). To avvoid this we can replace '-' with '/'
```PowerShell
'002130-563959-533643-315590-484044-259380-247291-123563' | BitLockerRKToBarcode -EncodeDashes
```

# QR-codes

To convert strings to QR-codes, take a look here: https://github.com/erlwes/PSStringToQRCode

* Pros
  * They can fit the whole recoverykey in one QR-code. One could actually fit a whole command/script like `'manage-bde -unlock c: -recoverypassword [KEY]`.
  * Scaning suffix like enter/carriage return code applied by some scanners it not a problem, since everything fits in one scan
  * If you have a 2D/CMOS reader, computer screens it not an issue at all, and lightingconditions etc. will not play a big role

* Cons
  * They require 2D/CMOS scanners, so the old scanners you have lying around might not work, and buying one costs more
