<#
    .SYNOPSIS
    Bounces the Mouse cursor around
    .DESCRIPTION
    
    .EXAMPLE

    .INPUTS


    .OUTPUTS

    
    .NOTES
    Script:         Start-CursorSave.ps1
    Author:         Murphy4444
    Creation Date:  26. Aug 2021
    Version:        1.0
    
    Version History
    -------
    Author:         
    Date:           
    Change Note:    
#>

#region Prerequisites
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
#endregion

class Direction {
    [int]$X
    [int]$Y
    
    Direction () {
        $this.X = Get-Random @((-5..-1 + 1..5))
        $this.Y = Get-Random @((-5..-1 + 1..5))
    }
}

class Position {
    [int]$X
    [int]$Y
    [int]$MinWidth
    [int]$MinHeight
    [int]$MaxWidth
    [int]$MaxHeight

    Position() {}

    Position ([bool]$scr) {
        $Screen = [System.Windows.Forms.Screen]::AllScreens |  Where-Object { $_.Primary -eq $true }
        $this.MinWidth = $Screen.Bounds.X
        $this.MinHeight = $Screen.Bounds.Y
        $this.MaxWidth = $Screen.Bounds.Width
        $this.MaxHeight = $Screen.Bounds.Height
        $this.X = Get-Random -Minimum ($this.MinWidth + 1) -Maximum ($this.MaxWidth - 1) 
        $this.Y = Get-Random -Minimum ($this.MinHeight + 1) -Maximum ($this.MaxHeight - 1)
    }

}

class Cursor {
    [Direction]$Direction
    [Position]$Position

    Cursor() {
        # These two will be random
        $this.Direction = [Direction]::new()    
        $this.Position = [Position]::new($true)
    }

    MoveCursor() {
        $newPos = $this.Position
        $newPos = $this.Position
        $newPos.X = [System.Windows.Forms.Cursor]::Position.X + $this.Direction.X
        $newPos.Y = [System.Windows.Forms.Cursor]::Position.Y + $this.Direction.Y

        if ($newPos.X -gt $newPos.MaxWidth) {
            $newPos.X = $newPos.MaxWidth + ($newPos.MaxWidth - $newPos.X)
            $this.Direction.X *= (-1)
        }
        elseif ($newPos.X -lt $newPos.MinWidth) {
            $newPos.X = ($newPos.X) * (-1)
            $this.Direction.X *= (-1)
        }
        if ($newPos.Y -gt $newPos.MaxHeight) {
            $newPos.Y = $newPos.MaxHeight + ($newPos.MaxHeight - $newPos.Y)
            $this.Direction.Y *= (-1)
        }
        elseif ($newPos.Y -lt $newPos.MinHeight) {
            $newPos.Y = ($newPos.Y) * (-1)
            $this.Direction.Y *= (-1)
        }

        $this.Position = $newPos
        [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($newPos.X, $newPos.Y)
    }
}

$Cursor = [Cursor]::new()

for (; ; ) {
    $Cursor.MoveCursor()
    Start-Sleep -Milliseconds 10
}


#endregion
