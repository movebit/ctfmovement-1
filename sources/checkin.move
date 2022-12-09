module ctfmovement::checkin {
    use std::signer;
    use aptos_framework::account;
    use aptos_framework::event;

    struct FlagHolder has key {
        event_set: event::EventHandle<Flag>,
    }

    struct Flag has drop, store {
        user: address,
        flag: bool
    }

    public entry fun get_flag(account: signer) acquires FlagHolder {
        let account_addr = signer::address_of(&account);
        if (!exists<FlagHolder>(account_addr)) {
            move_to(&account, FlagHolder {
                event_set: account::new_event_handle<Flag>(&account),
            });
        };

        let flag_holder = borrow_global_mut<FlagHolder>(account_addr);
        event::emit_event(&mut flag_holder.event_set, Flag {
            user: account_addr,
            flag: true
        });
    }
}
