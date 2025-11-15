# PowerShell script to add GitHub repository topics
# Usage: .\setup-github-topics.ps1 -Token YOUR_GITHUB_TOKEN

param(
    [string]$Token = $env:GITHUB_TOKEN
)

$RepoOwner = "Insider77Circle"
$RepoName = "Quantum-Topology-Prox"

if (-not $Token) {
    Write-Host "❌ Error: GitHub token required" -ForegroundColor Red
    Write-Host "Usage: .\setup-github-topics.ps1 -Token YOUR_GITHUB_TOKEN"
    Write-Host "Or set GITHUB_TOKEN environment variable"
    exit 1
}

# Topics to add (GitHub topics are lowercase, no spaces, use hyphens)
$Topics = @(
    "quantum",
    "cybersecurity",
    "tor",
    "proxy",
    "privacy",
    "anonymity",
    "ml-resistance",
    "machine-learning",
    "topology",
    "topological-computing",
    "quantum-computing",
    "network-security",
    "traffic-analysis",
    "correlation-attacks",
    "deepcorr",
    "timing-attacks",
    "privacy-tools",
    "security-research",
    "quantum-randomness",
    "winding-number",
    "np-hard",
    "cryptography",
    "defensive-security",
    "privacy-enhancing-technologies",
    "pet",
    "onion-routing",
    "proxychains",
    "stem",
    "rust",
    "python",
    "c",
    "ld-preload",
    "interposition",
    "runtime-security",
    "zero-trust",
    "adversarial-ml",
    "ml-security",
    "research",
    "cisco"
)

Write-Host "🚀 Adding topics to ${RepoOwner}/${RepoName}..." -ForegroundColor Cyan

# Prepare JSON payload
$Body = @{
    names = $Topics
} | ConvertTo-Json

# Set up headers
$Headers = @{
    "Accept" = "application/vnd.github.v3+json"
    "Authorization" = "token $Token"
    "Content-Type" = "application/json"
}

try {
    # Update repository topics using GitHub API
    $Response = Invoke-RestMethod -Uri "https://api.github.com/repos/${RepoOwner}/${RepoName}/topics" `
        -Method PUT `
        -Headers $Headers `
        -Body $Body

    Write-Host "✅ Successfully added topics!" -ForegroundColor Green
    $Response.names | ForEach-Object { Write-Host "   - $_" }
    
    Write-Host ""
    Write-Host "✨ Repository topics updated successfully!" -ForegroundColor Green
    Write-Host "📝 View your repository: https://github.com/${RepoOwner}/${RepoName}" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Error adding topics:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

