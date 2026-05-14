Add-Type -AssemblyName System.Drawing

function New-WispyIcon {
    param(
        [int]$Size,
        [string]$Path,
        [double]$Scale = 0.80,     # fraction of canvas used by Wispy body
        [bool]$RoundedBg = $true   # rounded square bg vs full bleed
    )

    $bmp = New-Object System.Drawing.Bitmap($Size, $Size)
    $g   = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode    = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.PixelOffsetMode  = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality

    # Background — pastel gradient
    $bgRect = New-Object System.Drawing.Rectangle 0, 0, $Size, $Size
    $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $bgRect,
        [System.Drawing.Color]::FromArgb(255, 255, 234, 242),
        [System.Drawing.Color]::FromArgb(255, 217, 241, 255),
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal)

    if ($RoundedBg) {
        # rounded square
        $radius = [int]($Size * 0.22)
        $bgPath = New-Object System.Drawing.Drawing2D.GraphicsPath
        $bgPath.AddArc(0, 0, $radius*2, $radius*2, 180, 90)
        $bgPath.AddArc($Size - $radius*2, 0, $radius*2, $radius*2, 270, 90)
        $bgPath.AddArc($Size - $radius*2, $Size - $radius*2, $radius*2, $radius*2, 0, 90)
        $bgPath.AddArc(0, $Size - $radius*2, $radius*2, $radius*2, 90, 90)
        $bgPath.CloseFigure()
        $g.FillPath($bgBrush, $bgPath)
    } else {
        $g.FillRectangle($bgBrush, $bgRect)
    }

    $cx = $Size / 2.0
    $cy = $Size / 2.0 + ($Size * 0.025)
    $r  = ($Size * $Scale) / 2.0 * 0.78  # body radius

    # soft glow halo
    $haloRect = New-Object System.Drawing.RectangleF(
        [single]($cx - $r * 1.4), [single]($cy - $r * 1.4),
        [single]($r * 2.8), [single]($r * 2.8))
    $haloPath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $haloPath.AddEllipse($haloRect)
    $haloBrush = New-Object System.Drawing.Drawing2D.PathGradientBrush($haloPath)
    $haloBrush.CenterColor   = [System.Drawing.Color]::FromArgb(180, 255, 213, 232)
    $haloBrush.SurroundColors = ,([System.Drawing.Color]::FromArgb(0, 255, 213, 232))
    $g.FillPath($haloBrush, $haloPath)

    # Ear-puffs
    $earR = $r * 0.32
    foreach ($side in @(-1, 1)) {
        $ex = $cx + $side * $r * 0.55
        $ey = $cy - $r * 0.72
        $earRect = New-Object System.Drawing.RectangleF(
            [single]($ex - $earR), [single]($ey - $earR),
            [single]($earR * 2), [single]($earR * 2))
        $earPath = New-Object System.Drawing.Drawing2D.GraphicsPath
        $earPath.AddEllipse($earRect)
        $earBrush = New-Object System.Drawing.Drawing2D.PathGradientBrush($earPath)
        $earBrush.CenterColor = [System.Drawing.Color]::White
        $earBrush.SurroundColors = ,([System.Drawing.Color]::FromArgb(255, 255, 208, 225))
        $earBrush.CenterPoint = New-Object System.Drawing.PointF(
            [single]($ex - $earR * 0.3), [single]($ey - $earR * 0.3))
        $g.FillPath($earBrush, $earPath)
    }

    # Body
    $bodyRect = New-Object System.Drawing.RectangleF(
        [single]($cx - $r), [single]($cy - $r),
        [single]($r * 2), [single]($r * 2))
    $bodyPath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $bodyPath.AddEllipse($bodyRect)
    $bodyBrush = New-Object System.Drawing.Drawing2D.PathGradientBrush($bodyPath)
    $bodyBrush.CenterColor = [System.Drawing.Color]::White
    $bodyBrush.SurroundColors = ,([System.Drawing.Color]::FromArgb(255, 255, 196, 216))
    $bodyBrush.CenterPoint = New-Object System.Drawing.PointF(
        [single]($cx - $r * 0.3), [single]($cy - $r * 0.3))
    $g.FillPath($bodyBrush, $bodyPath)

    # Cheeks
    $cheekR = $r * 0.18
    $cheekBrush = New-Object System.Drawing.SolidBrush(
        [System.Drawing.Color]::FromArgb(150, 255, 150, 180))
    foreach ($side in @(-1, 1)) {
        $g.FillEllipse($cheekBrush,
            [single]($cx + $side * $r * 0.45 - $cheekR),
            [single]($cy + $r * 0.18 - $cheekR),
            [single]($cheekR * 2), [single]($cheekR * 2))
    }

    # Eyes (oval)
    $eyeBrush = New-Object System.Drawing.SolidBrush(
        [System.Drawing.Color]::FromArgb(255, 90, 63, 106))
    $eW = $r * 0.10
    $eH = $r * 0.14
    foreach ($side in @(-1, 1)) {
        $ex = $cx + $side * $r * 0.32
        $ey = $cy - $r * 0.10
        $g.FillEllipse($eyeBrush,
            [single]($ex - $eW), [single]($ey - $eH),
            [single]($eW * 2), [single]($eH * 2))
    }

    # Eye highlights
    $hlBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $hR = $r * 0.03
    foreach ($side in @(-1, 1)) {
        $ex = $cx + $side * $r * 0.32 + $eW * 0.3
        $ey = $cy - $r * 0.10 - $eH * 0.4
        $g.FillEllipse($hlBrush,
            [single]($ex - $hR), [single]($ey - $hR),
            [single]($hR * 2), [single]($hR * 2))
    }

    # Smile
    $smilePen = New-Object System.Drawing.Pen(
        [System.Drawing.Color]::FromArgb(255, 90, 63, 106),
        [single]($r * 0.055))
    $smilePen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $smilePen.EndCap   = [System.Drawing.Drawing2D.LineCap]::Round
    $smileR = $r * 0.18
    $smileRect = New-Object System.Drawing.RectangleF(
        [single]($cx - $smileR),
        [single]($cy + $r * 0.05 - $smileR * 0.4),
        [single]($smileR * 2), [single]($smileR * 0.9))
    $g.DrawArc($smilePen, $smileRect, 27, 126)

    $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Host "Wrote $Path"
}

$root = "C:\Users\Jovri\Desktop\Wispy-Wander"
# Standard "any" purpose — full-bleed
New-WispyIcon -Size 192 -Path "$root\icon-192.png"  -Scale 0.90 -RoundedBg $true
New-WispyIcon -Size 512 -Path "$root\icon-512.png"  -Scale 0.90 -RoundedBg $true
# Apple touch icon — same look at 180px (iOS expected size)
New-WispyIcon -Size 180 -Path "$root\apple-touch-icon.png" -Scale 0.90 -RoundedBg $true
# Maskable — Wispy scaled into the 80% safe area
New-WispyIcon -Size 512 -Path "$root\icon-512-maskable.png" -Scale 0.62 -RoundedBg $false
# Favicon
New-WispyIcon -Size 32  -Path "$root\favicon-32.png" -Scale 0.95 -RoundedBg $true

Write-Host "All icons generated."
