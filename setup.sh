#!/bin/bash

# Claude Dev Workflow Setup Script
# Run from your project root after adding the submodule

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "Claude Dev Workflow Setup"
echo "========================="
echo ""

# Check if running from correct location
if [ ! -d "$SCRIPT_DIR/skills" ]; then
    echo "Error: Script must be run from the submodule directory"
    echo "Usage: ./.claude-workflow/setup.sh"
    exit 1
fi

cd "$PROJECT_ROOT"

# Create .claude/commands directory
echo "Creating .claude/commands directory..."
mkdir -p .claude/commands

# Create skill symlinks
echo "Creating skill symlinks..."
SKILLS=(comms adr memory recall)
WORKFLOW_SKILLS=(context.skill reflect.skill refine.skill)

for skill in "${SKILLS[@]}"; do
    if [ ! -L ".claude/commands/${skill}.md" ]; then
        ln -sf "../../.claude-workflow/skills/${skill}.md" ".claude/commands/${skill}.md"
        echo "  Linked: ${skill}.md"
    else
        echo "  Exists: ${skill}.md"
    fi
done

for skill in "${WORKFLOW_SKILLS[@]}"; do
    name=$(echo "$skill" | sed 's/.skill//')
    if [ ! -L ".claude/commands/${name}.md" ]; then
        ln -sf "../../.claude-workflow/skills/${skill}.md" ".claude/commands/${name}.md"
        echo "  Linked: ${name}.md"
    else
        echo "  Exists: ${name}.md"
    fi
done

# Create or update settings.json
echo ""
echo "Checking .claude/settings.json..."
if [ ! -f ".claude/settings.json" ]; then
    cat > .claude/settings.json << 'EOF'
{
  "permissions": {
    "additionalDirectories": [
      "../claude-dev-workflow"
    ]
  }
}
EOF
    echo "  Created settings.json"
else
    echo "  settings.json exists - please verify additionalDirectories includes '../claude-dev-workflow'"
fi

# Ask about dev_communication
echo ""
echo "Dev Communication Setup"
echo "-----------------------"
if [ -d "dev_communication" ]; then
    echo "dev_communication/ already exists - skipping"
elif [ -L "dev_communication" ]; then
    echo "dev_communication/ is a symlink - skipping"
else
    read -p "Create dev_communication directory? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp -r "$SCRIPT_DIR/scaffolds/dev_communication" ./dev_communication
        echo "Created dev_communication/ from scaffold"
    fi
fi

# Ask about memory
echo ""
echo "Memory Vault Setup"
echo "------------------"
if [ -d "memory" ]; then
    echo "memory/ already exists - skipping"
else
    read -p "Create memory vault directory? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp -r "$SCRIPT_DIR/scaffolds/memory" ./memory
        echo "Created memory/ from scaffold"
    fi
fi

echo ""
echo "Setup Complete!"
echo ""
echo "Next steps:"
echo "1. Review .claude/settings.json"
echo "2. Add workflow section to CLAUDE.md (see SETUP.md)"
echo "3. Initialize team status in dev_communication/coordination/"
echo "4. Create initial context in memory/context/"
echo ""
echo "Available skills: /comms /adr /memory /recall /context /reflect /refine"
