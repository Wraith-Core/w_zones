// Native RDR2 location shard (_UI_FEED_POST_LOCATION_SHARD)
// Zero NUI — renders using the game's own built-in location banner.

exports('ShowLocationBanner', (subtitle, title, duration) => {
    const struct1 = new DataView(new ArrayBuffer(48));
    struct1.setInt32(0, Number(duration) || 4000, true);

    const locStr = CreateVarString(10, 'LITERAL_STRING', String(title || ''));
    const subStr = CreateVarString(10, 'LITERAL_STRING', String(subtitle || ''));

    const struct2 = new DataView(new ArrayBuffer(24));
    struct2.setBigInt64(8, BigInt(locStr), true);
    struct2.setBigInt64(16, BigInt(subStr), true);

    Citizen.invokeNative('0xD05590C1AB38F068', struct1, struct2, 1, 1);
});
