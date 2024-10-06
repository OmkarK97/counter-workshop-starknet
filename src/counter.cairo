#[starknet::interface]
pub trait ICounter<T>{
    fn get_counter(self: @T) -> u32;
    fn increase_counter(ref self: T);
}


#[starknet::contract]
pub mod counter_contract {
    use starknet::event::EventEmitter;
use workshop::counter::ICounter; 

    #[storage]
    struct Storage {
        counter: u32,
    }

    #[constructor]
    fn constructor(ref self: ContractState, initial_value: u32) {
        self.counter.write(initial_value);
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event{
        CounterIncreased: CounterIncreased,
    }

    #[derive(Drop, starknet::Event)]
    struct CounterIncreased {
        value: u32,
    }

    #[abi(embed_v0)]
    impl CounterImpl of ICounter<ContractState> {
        fn get_counter(self: @ContractState) -> u32 {
            // let value = self.counter.read();
            // return value;
            self.counter.read()
        }

        fn increase_counter(ref self: ContractState) {
            // let value = self.get_counter();
            // self.counter.write(value + 1);

            self.counter.write(self.get_counter() + 1 );
            self.emit(CounterIncreased{value: self.counter.read()});
        }
    }
}