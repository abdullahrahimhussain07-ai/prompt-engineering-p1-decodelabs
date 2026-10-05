function Extract-SupportData {
    param ([string]$inputText)

    # 1. Customer Name
    $name = if ($inputText -match "(?:my name is|From:|this is)\s+([A-Z][a-z]+(?:\s+[A-Z][a-z]+)?)") { $Matches[1] } else { $null }

    # 2. Order Number
    $order = if ($inputText -match "(?:order #?|item #?)\s*([A-Z0-9\-]+)") { $Matches[1] } else { $null }

    # 3. Complaint Type
    $complaint = "OTHER"
    if ($inputText -match "shattered|broken|damaged|scratch|overheated") {
        $complaint = "DAMAGED_PRODUCT"
    } elseif ($inputText -match "hasn't arrived|late|delayed|missing") {
        $complaint = "LATE_DELIVERY"
    } elseif ($inputText -match "charge|billing|refund|bills") {
        $complaint = "BILLING_ERROR"
    }

    # 4. Severity Level Logic
    $severity = 3
    if ($inputText -match "sue|lawyer|legal|safety|overheated|unusable|immediately") {
        $severity = 5
    } elseif ($inputText -match "minor scratch|tiny scratch|store hours|quick question") {
        $severity = 1
    }

    # 5. Contact Phone Logic
    $phone = $null
    if ($inputText -match "(?:brother|sister|friend|colleague|lawyer)\s+.*?\+?\d+") {
        $phone = $null
    } elseif ($inputText -match "(?:call me at|reach me at|my phone|contact me at)\s+([\+\d\s\-]{10,15})") {
        $phone = $Matches[1].Trim()
    } elseif ($inputText -match "(03\d{9}|\+\d{11,12})") {
        $phone = $Matches[1]
    }

    return [PSCustomObject]@{
        customer_name  = $name
        order_number   = $order
        complaint_type = $complaint
        severity_level = $severity
        contact_phone  = $phone
    }
}

# --- EDGE CASES SUITE ---
$edgeCases = @(
    @{ id = 1; name = "Wrong Person Phone"; email = "My name is Ahmed Raza, order #5521. The charger overheated. You can reach my brother-in-law Fahad at +92 300 1234567, he handles my bills." },
    @{ id = 2; name = "Not-a-Phone Number"; email = "Order #9982 is missing. Reference: 8847-2210. Call me at 03001234567." },
    @{ id = 3; name = "Severity Override Conflict"; email = "Minor scratch on the frame (severity 1), but I'm a lawyer and will sue if not fixed by Friday." },
    @{ id = 4; name = "Multiple Orders"; email = "I ordered #1111 and #2222. #1111 arrived broken, #2221 hasn't arrived." },
    @{ id = 5; name = "Emotional Severity Inflation"; email = "I'm SO ANGRY about this tiny scratch!!! Worst experience EVER!!!" }
)

$results = foreach ($case in $edgeCases) {
    [PSCustomObject]@{
        test_id     = $case.id
        test_name   = $case.name
        parsed_data = Extract-SupportData -inputText $case.email
    }
}

# Update output.json
$results | ConvertTo-Json -Depth 5 | Out-File -FilePath "$HOME\Desktop\powershell-support-parser\output.json" -Encoding utf8
