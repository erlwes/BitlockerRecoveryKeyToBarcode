# BitlockerRecoveryKeyToBarcode
Generates barcodes from BitLocker Recovery Keys and display it on screen.

* The script needs to have the "Code39"-barcodefont installed (Code 39 Standard used): https://www.dafont.com/code39.font
* The input only accepts valid Bitlocker-keys
* Inspired by this article: https://www.theregister.com/2024/07/25/crowdstrike_remediation_with_barcode_scanner/

Example Bitlocker Recovery Key:
`002130-563959-533643-315590-484044-259380-247291-123563`

![image](https://github.com/user-attachments/assets/10f477fa-79d7-4e15-ae3b-05bbef32760a)

# Tips 💡
Hitting the "Escape" character on your keyboard will close the GUI and you will return to your shell

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
BitLockerRKToBarcode -useAlternativeBarcodeFont "Libre Barcode 128 Regular"
```
