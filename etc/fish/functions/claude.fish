# The usual way to run claude, see go/ai
function claude
    set -fx ALLIUM_API_KEY 'op://Employee/Allium API Key/credential'

    op run --no-masking -- \
        claude --dangerously-skip-permissions $argv
end
