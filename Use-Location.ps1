function Use-Location {
    param (
        [Parameter(Mandatory)]
        [string]
        $Location,

        [scriptblock]
        $Expression
    )
    begin { Push-Location $Location }
    process {
        $Expression.Invoke()
    }
    end { Pop-Location }
}
