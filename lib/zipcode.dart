import 'data/zcta.g.dart';
import 'package:quiver/collection.dart';
import 'package:geohash_int/geohash_int.dart';

class ZipCode {
    final int zip;
    final double lat;
    final double lon;
    final int hash;

    const ZipCode({this.zip, this.lat, this.lon, this.hash});
    @override
    String toString() => "ZipCode($zip, [$lat, $lon], $hash)";
}

class ZipCodeGeoDB {
    // ZCTA database uses WGS84 datum
    static final _lat_range = GeoHashRange(
        GeoHashRange.WGS84_LAT_MIN,
        GeoHashRange.WGS84_LAT_MAX
    );
    static final _lon_range = GeoHashRange(
        GeoHashRange.WGS84_LON_MIN,
        GeoHashRange.WGS84_LON_MAX
    );
    // total hash width = 52 bits, about 60cm precision
    static final _hash_step = 26;
    static final _db  = TreeSet<ZipCode>(
        comparator: (a, b) => a.hash - b.hash
    );

    void _init() {
        if(ZCTAhashed_bits != _hash_step ||
           ZCTAhashed_lat_range != _lat_range ||
           ZCTAhashed_lon_range != _lon_range)
            {
                throw AssertionError("Precompiled data settings do not match runtime");
            }
        ZCTAhashed.forEach((zip, data) {
            final List<double> coord = data[0];
            _db.add(ZipCode(
                zip: zip,
                lat: coord[0],
                lon: coord[1],
                hash: data[1]
            ));
        });
    }

    // Idempotent = true makes constructor initialize the data every time
    // it gets called. For benchmarking and testing mostly.
    ZipCodeGeoDB({idempotent: false}) {
        if(_db.isEmpty || idempotent)
            _init();
    }


    // Returns a list of zip code objects near the given coordinates
    // Accepts coordinates in WGS84 datum
    // May return:
    //    null on failure
    //    zero length list if no zip codes were found
    //    single item list if radius is not specified (nearest zip)
    //    multiple items within radius
    List<ZipCode> lookup(double lat, double lon, {double radius}) {
        validateCoords(lat, lon);
        final hash = geohash_fast_encode(
            _lat_range, _lon_range, lat, lon, _hash_step
        );
        if(radius == null) {
            final zip = _db.nearest(ZipCode(hash: hash.bits));
            return zip == null? null: [zip];
        } else {
            final hood = geohash_get_areas_by_radius(lat, lon, radius);
            hood.forEach((hash){
                print("$hash");
            });
        }
        return null;
    }

}

