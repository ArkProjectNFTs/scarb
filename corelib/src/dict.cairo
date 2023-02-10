extern type DictManager;
extern type DictFeltTo<T>;
extern type SquashedDictFeltTo<T>;
impl SquashedDictFeltToFeltDrop of Drop::<SquashedDictFeltTo::<felt>>;

extern fn dict_felt_to_new<T>() -> DictFeltTo::<T> implicits(DictManager) nopanic;
extern fn dict_felt_to_write<T>(ref dict: DictFeltTo::<T>, key: felt, value: T) nopanic;
extern fn dict_felt_to_read<T>(ref dict: DictFeltTo::<T>, key: felt) -> T nopanic;
extern fn dict_felt_to_squash<T>(
    dict: DictFeltTo::<T>
) -> SquashedDictFeltTo::<T> implicits(RangeCheck, GasBuiltin, DictManager) nopanic;

trait DictFeltToTrait<T> {
    fn new() -> DictFeltTo::<T>;
    fn insert(ref self: DictFeltTo::<T>, key: felt, value: T);
    fn get(ref self: DictFeltTo::<T>, key: felt) -> T;
    fn squash(self: DictFeltTo::<T>) -> SquashedDictFeltTo::<T>;
}
impl DictFeltToImpl<T> of DictFeltToTrait::<T> {
    fn new() -> DictFeltTo::<T> {
        dict_felt_to_new()
    }
    fn insert(ref self: DictFeltTo::<T>, key: felt, value: T) {
        dict_felt_to_write(ref self, key, value)
    }
    fn get(ref self: DictFeltTo::<T>, key: felt) -> T {
        dict_felt_to_read(ref self, key)
    }
    fn squash(self: DictFeltTo::<T>) -> SquashedDictFeltTo::<T> {
        // TODO(ilya): Currently prevents inlining. remove after adding #[inline(never)].
        let _ignore = 'extra-statement';
        dict_felt_to_squash(self)
    }
}
