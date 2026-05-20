function production-replica
    # op account list
    # op vault list
    # op item list --vault VAULT
    set -f VAULT 'p3hh25rpgtgb6codrqakfh2o3y'
    set -f ITEM 'vy6j52fj24tf6lox2fvsm4rnhu'

    mise exec --cd ~/stripe/monorail -- \
        env PROD_REPLICA_PASSWORD="op://$VAULT/$ITEM/password" \
        op run --no-masking -- \
        bin/rails_console_production_replica
end
