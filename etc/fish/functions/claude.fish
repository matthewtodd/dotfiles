# The usual way to run claude, see go/ai
function claude
    # Use this if I ever want the allium mcp:
    # set -fx ALLIUM_API_KEY 'op://Employee/Allium API Key/credential'
    # op run --no-masking -- \
        # claude --dangerously-skip-permissions $argv

    # Use a dummy ALLIUM_API_KEY to avoid warnings:
    set -fx ALLIUM_API_KEY ''
    command claude --dangerously-skip-permissions $argv
end
