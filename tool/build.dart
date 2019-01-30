import 'dart:async';
import 'package:build/build.dart';
import 'package:geohash_int/geohash_int.dart';
import '../lib/data/zcta.dart' as data;

// ZCTA database uses WGS84 datum
final  _lat_range = GeoHashRange(
    GeoHashRange.WGS84_LAT_MIN,
    GeoHashRange.WGS84_LAT_MAX
);
final _lon_range = GeoHashRange(
    GeoHashRange.WGS84_LON_MIN,
    GeoHashRange.WGS84_LON_MAX
);
// total hash width = 52 bits, about 60cm precision
const int _hash_step = 26;

Future main(List<String> args) async {
    print("// GENERATED FILE, DO NOT EDIT!!!");
    print("// int zip: [[double lat, double lon], int hash]");
    print("import 'package:geohash_int/geohash_int.dart';");
    print("const ZCTAhashed_bits = $_hash_step;");
    print("final ZCTAhashed_lat_range = $_lat_range;");
    print("final ZCTAhashed_lon_range = $_lon_range;");
    print("const ZCTAhashed = {");
    data.ZCTA.forEach((zip, coord) {
        final hash = geohash_fast_encode(
            _lat_range,
            _lon_range,
            coord[0],
            coord[1],
            _hash_step
        );
        print("$zip:[[${coord[0]},${coord[1]}],${hash.bits}],");
    });
    print("};");
}

