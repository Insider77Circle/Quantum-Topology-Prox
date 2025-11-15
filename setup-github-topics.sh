#!/bin/bash
# Script to add GitHub repository topics
# Usage: ./setup-github-topics.sh [GITHUB_TOKEN]

set -e

REPO_OWNER="Insider77Circle"
REPO_NAME="Quantum-Topology-Prox"
GITHUB_TOKEN="${1:-$GITHUB_TOKEN}"

if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ Error: GitHub token required"
    echo "Usage: ./setup-github-topics.sh YOUR_GITHUB_TOKEN"
    echo "Or set GITHUB_TOKEN environment variable"
    exit 1
fi

# Topics to add (GitHub topics are lowercase, no spaces, use hyphens)
TOPICS=(
    "quantum"
    "cybersecurity"
    "tor"
    "proxy"
    "privacy"
    "anonymity"
    "ml-resistance"
    "machine-learning"
    "topology"
    "topological-computing"
    "quantum-computing"
    "network-security"
    "traffic-analysis"
    "correlation-attacks"
    "deepcorr"
    "timing-attacks"
    "privacy-tools"
    "security-research"
    "quantum-randomness"
    "winding-number"
    "np-hard"
    "cryptography"
    "defensive-security"
    "privacy-enhancing-technologies"
    "pet"
    "onion-routing"
    "proxychains"
    "stem"
    "rust"
    "python"
    "c"
    "ld-preload"
    "interposition"
    "runtime-security"
    "zero-trust"
    "adversarial-ml"
    "ml-security"
    "research"
    "cisco"
)

echo "🚀 Adding topics to ${REPO_OWNER}/${REPO_NAME}..."

# Convert topics array to JSON format
TOPICS_JSON=$(printf '%s\n' "${TOPICS[@]}" | jq -R . | jq -s .)

# Update repository topics using GitHub API
RESPONSE=$(curl -s -X PUT \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"names\": ${TOPICS_JSON}}" \
    "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/topics")

# Check if successful
if echo "$RESPONSE" | grep -q '"names"'; then
    echo "✅ Successfully added topics!"
    echo "$RESPONSE" | jq -r '.names[]' | sed 's/^/   - /'
else
    echo "❌ Error adding topics:"
    echo "$RESPONSE" | jq '.'
    exit 1
fi

echo ""
echo "✨ Repository topics updated successfully!"
echo "📝 View your repository: https://github.com/${REPO_OWNER}/${REPO_NAME}"

