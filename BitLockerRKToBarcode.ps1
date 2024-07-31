Function BitLockerRKToBarcode {
    Param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)][ValidateScript({$_ -match '^\d{6}-\d{6}-\d{6}-\d{6}-\d{6}-\d{6}-\d{6}-\d{6}$'}, ErrorMessage = 'Please enter a valid BitLocker Recovery Key (48 digits in 8 groups of 6 digits separated by hyphens')]
        [string]$BitlockerRecoveryKey,
        [string]$useAlternativeBarcodeFont,
        [switch]$EncodeDashes #Use if scanned '-' turns into '+'
    )

    Function GenerateBarcodes {
        if ($BitlockerRecoveryKey -match '^\d{6}-\d{6}-\d{6}-\d{6}-\d{6}-\d{6}-\d{6}-\d{6}$' -and $Script:FromPipline -ne 'Done') {
            $inputText = $BitlockerRecoveryKey
            $TextBox.Text = $BitlockerRecoveryKey
            $Script:FromPipline = 'Done'          
        }
        else {
            $inputText = $TextBox.Text
        }        
        if ($inputText -match '^\d{6}-\d{6}-\d{6}-\d{6}-\d{6}-\d{6}-\d{6}-\d{6}$') {            
            $part1 = "*$($inputText.Substring(0, 20))*"  # First 20 characters (first three groups)
            $barCodeLabel1.Text = "Part one ($part1)"

            $part2 = "*$($inputText.Substring(20, 20))*" # Next 20 characters (next three groups)
            $barCodeLabel2.Text = "Part two ($part2)"
            
            $part3 = "*$($inputText.Substring(40, 15))*" # Last 15 characters (last two groups)
            $barCodeLabel3.Text = "Part three ($part3)"

            if ($EncodeDashes) {
                $part1 = $part1 -replace '-', '/'
                $part2 = $part2 -replace '-', '/'
                $part3 = $part3 -replace '-', '/'
            }

            $oLabel1.Text = "$part1"
            $oLabel2.Text = "$part2"
            $oLabel3.Text = "$part3"

        } else {
            [System.Windows.Forms.MessageBox]::Show("Please enter a valid BitLocker Recovery Key (48 digits in 8 groups of 6 digits separated by hyphens).")
        }
    }

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $Font = New-Object System.Drawing.Font("Arial", 10)
    
    $Form = New-Object System.Windows.Forms.Form
    $Form.Width = 685
    $Form.Height = 720
    $Form.Font = $Font
    $Form.Text = "BitLocker Recovery Key Barcode Generator"
    $Form.Add_KeyDown({
        param (
            [System.Object]$sender,
            [System.Windows.Forms.KeyEventArgs]$e
        )        
        if ($e.KeyCode -eq [System.Windows.Forms.Keys]::Escape) {
            $form.Close()
        }
    })
    $Form.KeyPreview = $true
    
    $InputLabel = New-Object System.Windows.Forms.Label
    $InputLabel.Text = "Enter BitLocker Recovery Key:"
    $InputLabel.Location = New-Object System.Drawing.Size(50, 30)
    $InputLabel.Size = New-Object System.Drawing.Size(250, 18)
    $Form.Controls.Add($InputLabel)
    
    $TextBox = New-Object System.Windows.Forms.TextBox
    $TextBox.Location = New-Object System.Drawing.Size(50, 50)
    $TextBox.Size = New-Object System.Drawing.Size(400, 32)
    $Form.Controls.Add($TextBox)
    
    $GenerateButton = New-Object Windows.Forms.Button
    $GenerateButton.Text = "Generate Barcodes"
    $GenerateButton.Location = New-Object System.Drawing.Size(470, 50)
    $GenerateButton.Width = 150
    $Form.Controls.Add($GenerateButton)

    # Barcode 1    
    $global:oLabel1 = New-Object System.Windows.Forms.Label
    $oLabel1.Location = New-Object System.Drawing.Size(50, 150)
    $oLabel1.Size = New-Object System.Drawing.Size(570, 80)
    $oLabel1.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $oLabel1.BackColor = 'White'

    $barCodeLabel1 = New-Object System.Windows.Forms.Label
    $barCodeLabel1.Text = ''
    $barCodeLabel1.Location = New-Object System.Drawing.Size($oLabel1.Location.X, ($oLabel1.Location.Y - 25))
    $barCodeLabel1.Size = New-Object System.Drawing.Size(570, 30)
    $Form.Controls.Add($barCodeLabel1)
    
    # Barcode 2
    $global:oLabel2 = New-Object System.Windows.Forms.Label
    $oLabel2.Location = New-Object System.Drawing.Size(50, ($oLabel1.Location.Y + 200))  
    $oLabel2.Size = New-Object System.Drawing.Size(570, 80)
    $oLabel2.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $oLabel2.BackColor = 'White'

    $barCodeLabel2 = New-Object System.Windows.Forms.Label
    $barCodeLabel2.Text = ''
    $barCodeLabel2.Location = New-Object System.Drawing.Size($oLabel2.Location.X, ($oLabel2.Location.Y - 25))    
    $barCodeLabel2.Size = New-Object System.Drawing.Size(570, 30)
    $Form.Controls.Add($barCodeLabel2)

    # Barcode 3
    $global:oLabel3 = New-Object System.Windows.Forms.Label
    $oLabel3.Location = New-Object System.Drawing.Size(50, ($oLabel2.Location.Y + 200))
    $oLabel3.Size = New-Object System.Drawing.Size(570, 80)
    $oLabel3.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $oLabel3.BackColor = 'White'

    $barCodeLabel3 = New-Object System.Windows.Forms.Label
    $barCodeLabel3.Text = ''
    $barCodeLabel3.Location = New-Object System.Drawing.Size($oLabel3.Location.X, ($oLabel3.Location.Y - 25))    
    $barCodeLabel3.Size = New-Object System.Drawing.Size(570, 30)
    $Form.Controls.Add($barCodeLabel3)

    #Set the barcode font, and verify that it is installed
    if ($useAlternativeBarcodeFont) {
        $barcodeFontName = $useAlternativeBarcodeFont
        if ($barcodeFontName  -eq 'Libre Barcode 128') {
            $barcodeFont = New-Object System.Drawing.Font($barcodeFontName, 80)
        }
        else {
            $barcodeFont = New-Object System.Drawing.Font($barcodeFontName, 30)    
        }        
    }
    else {
        $barcodeFontName = "CCode39"
        $barcodeFont = New-Object System.Drawing.Font($barcodeFontName, 14)
    }
    
    if ($barcodeFont.Name -ne $barcodeFontName) {
        [System.Windows.Forms.MessageBox]::Show("Failed to set barcode font. Please ensure 'CCode39' font is installed.")
        return
    }
    $oLabel1.Font = $barcodeFont
    $oLabel2.Font = $barcodeFont
    $oLabel3.Font = $barcodeFont

    $Form.Controls.Add($oLabel1)
    $Form.Controls.Add($oLabel2)
    $Form.Controls.Add($oLabel3)
    
    $GenerateButton.add_Click({
        GenerateBarcodes
    })

    if ($BitlockerRecoveryKey) {
        Write-Verbose 'Bitlocker Key received from pipeline'
        $Script:FromPipline = 'NotDone'
        GenerateBarcodes
    }

    $Form.Add_Shown({$Form.Activate()})
    $Form.ShowDialog() | Out-Null
}

BitLockerRKToBarcode
