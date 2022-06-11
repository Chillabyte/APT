param (
  $seconds = 10
)
Function Get-ScreenCapture{
	param(
	   $of="cap")
	   
	Add-Type -AssemblyName System.Windows.Forms,System.Drawing

	$screens = [Windows.Forms.Screen]::AllScreens

	$top    = ($screens.Bounds.Top    | Measure-Object -Minimum).Minimum
	$left   = ($screens.Bounds.Left   | Measure-Object -Minimum).Minimum
	$width  = ($screens.Bounds.Right  | Measure-Object -Maximum).Maximum
	$height = ($screens.Bounds.Bottom | Measure-Object -Maximum).Maximum

	$bounds   = [Drawing.Rectangle]::FromLTRB($left, $top, $width, $height)
	$bmp      = New-Object System.Drawing.Bitmap ([int]$bounds.width), ([int]$bounds.height)
	$graphics = [Drawing.Graphics]::FromImage($bmp)

	$graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)
	$DTString = get-date -UFormat "%Y%m%d-%H%M%S"
    $FileBasePath = "$env:USERPROFILE\WorkCaptures"
    if(-not (Test-Path $FileBasePath)) {New-Item $FileBasePath -ItemType Directory}

	$bmp.Save("$of-$DTString.png")

	$graphics.Dispose()
	$bmp.Dispose()
}

while (1) {
 Start-Sleep -Seconds $Seconds
 Get-ScreenCapture
}