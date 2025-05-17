module MyModule::FoodDonationChain {
    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct to track food donation info
    struct DonationTracker has key, store {
        total_donated: u64,
    }

    /// Initialize donation tracker for a food organization
    public fun initialize_tracker(organization: &signer) {
        let tracker = DonationTracker {
            total_donated: 0,
        };
        move_to(organization, tracker);
    }

    /// Donate tokens to a food organization
    public fun donate(donor: &signer, organization_addr: address, amount: u64) acquires DonationTracker {
        let tracker = borrow_global_mut<DonationTracker>(organization_addr);

        // Withdraw coins from donor
        let donation = coin::withdraw<AptosCoin>(donor, amount);

        // Deposit to organization
        coin::deposit<AptosCoin>(organization_addr, donation);

        // Update total donated
        tracker.total_donated = tracker.total_donated + amount;
    }
}
