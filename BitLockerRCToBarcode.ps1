Function BitLockerRCToBarcode {
    Param(
        [string]$useAlternativeBarcodeFont
    )
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $Form = New-Object System.Windows.Forms.Form    
    $Form.width = 1015
    $Form.height = 1200
    $Form.Text = "BitLocker Recovery Key Barcode Generator"

    $Font = New-Object System.Drawing.Font("Arial", 10)
    $Form.Font = $Font
    
    $InputLabel = New-Object System.Windows.Forms.Label
    $InputLabel.Text = "Enter BitLocker Recovery Key:"
    $InputLabel.Location = New-Object System.Drawing.Size(50, 70)
    $InputLabel.Size = New-Object System.Drawing.Size(250, 25)
    $Form.Controls.Add($InputLabel)
    
    $TextBox = New-Object System.Windows.Forms.TextBox
    $TextBox.Location = New-Object System.Drawing.Size(50, 100)
    $TextBox.Size = New-Object System.Drawing.Size(400, 30)
    $Form.Controls.Add($TextBox)
    
    $GenerateButton = New-Object Windows.Forms.Button
    $GenerateButton.Text = "Generate Barcodes"
    $GenerateButton.Top = 100
    $GenerateButton.Left = 470
    $GenerateButton.Width = 150
    $Form.Controls.Add($GenerateButton)

    # Add and set the BarCode text and TTF Font for three labels
    $barCodeLabel1 = New-Object System.Windows.Forms.Label
    $barCodeLabel1.Text = ''
    $barCodeLabel1.Location = New-Object System.Drawing.Size(50, 170)
    $barCodeLabel1.Size = New-Object System.Drawing.Size(900, 30)
    $Form.Controls.Add($barCodeLabel1)
    
    $global:oLabel1 = New-Object System.Windows.Forms.Label
    $oLabel1.Location = New-Object System.Drawing.Size(50, 200)
    $oLabel1.Size = New-Object System.Drawing.Size(900, 80)
    $oLabel1.BackColor = 'White'
    $Form.Controls.Add($oLabel1)

    $barCodeLabel2 = New-Object System.Windows.Forms.Label
    $barCodeLabel2.Text = ''
    $barCodeLabel2.Location = New-Object System.Drawing.Size(50, 570)
    $barCodeLabel2.Size = New-Object System.Drawing.Size(900, 30)
    $Form.Controls.Add($barCodeLabel2)

    $global:oLabel2 = New-Object System.Windows.Forms.Label
    $oLabel2.Location = New-Object System.Drawing.Size(50, 600)    
    $oLabel2.Size = New-Object System.Drawing.Size(900, 80)
    $oLabel2.BackColor = 'White'

    $barCodeLabel3 = New-Object System.Windows.Forms.Label
    $barCodeLabel3.Text = ''
    $barCodeLabel3.Location = New-Object System.Drawing.Size(50, 970)
    $barCodeLabel3.Size = New-Object System.Drawing.Size(900, 30)
    $Form.Controls.Add($barCodeLabel3)

    $global:oLabel3 = New-Object System.Windows.Forms.Label
    $oLabel3.Location = New-Object System.Drawing.Size(50, 1000)
    $oLabel3.Size = New-Object System.Drawing.Size(900, 80)
    $oLabel3.BackColor = 'White'

    if ($useAlternativeBarcodeFont) {
        $barcodeFont = $useAlternativeBarcodeFont
    }
    else {
        $barcodeFontName = "CCode39"
    }
    
    $barcodeFont = New-Object System.Drawing.Font($barcodeFontName, 30)
    
    if ($barcodeFont.Name -ne $barcodeFontName) {
        [System.Windows.Forms.MessageBox]::Show("Failed to set barcode font. Please ensure 'CCode39' font is installed.")
        return
    }

    $oLabel1.Font = $barcodeFont
    $oLabel2.Font = $barcodeFont
    $oLabel3.Font = $barcodeFont

    
    $Form.Controls.Add($oLabel2)
    $Form.Controls.Add($oLabel3)
    
    $GenerateButton.add_Click({
        $inputText = $TextBox.Text
        if ($inputText -match '^\d{6}-\d{6}-\d{6}-\d{6}-\d{6}-\d{6}-\d{6}-\d{6}$') {            
            $part1 = "*$($inputText.Substring(0, 20))*"  # First 20 characters (first three groups)
            $barCodeLabel1.Text = "Part one ($part1)"
            $oLabel1.Text = "$part1"

            $part2 = "*$($inputText.Substring(20, 20))*" # Next 20 characters (next three groups)
            $barCodeLabel2.Text = "Part two ($part2)"
            $oLabel2.Text = "$part2"

            $part3 = "*$($inputText.Substring(40, 15))*" # Last 15 characters (last two groups)
            $barCodeLabel3.Text = "Part three ($part3)"
            $oLabel3.Text = "$part3"           
        } else {
            [System.Windows.Forms.MessageBox]::Show("Please enter a valid BitLocker Recovery Key (48 digits in 8 groups of 6 digits separated by hyphens).")
        }
    })
    $Form.Add_Shown({$Form.Activate()})
    $Form.ShowDialog() | Out-Null
}

BitLockerRCToBarcode
