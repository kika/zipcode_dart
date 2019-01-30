import 'package:benchmark_harness/benchmark_harness.dart';
import '../lib/zipcode.dart';

class ZipTestResults {
    static List<ZipCode> zipSingle;
}

class ZipDBBench1 extends BenchmarkBase {
    ZipDBBench1() : super("Initialize db");

    void run() {
        final db = ZipCodeGeoDB(idempotent: true);
    }
}

class ZipDBBench2 extends BenchmarkBase {
    ZipCodeGeoDB db;
    ZipDBBench2() : super("Nearest lookup");

    void setup() {
        db = ZipCodeGeoDB();
    }

    void run() {
        ZipTestResults.zipSingle = db.lookup(37.4270, -122.1989);
    }
}

void test1() {
    final db = ZipCodeGeoDB();
    final zip = db.lookup(37.4270, -122.1989);
    print("ZIP: $zip");
}
void test2() {
    final db = ZipCodeGeoDB();
    final zips = db.lookup(37.4270, -122.1989, radius: 30000);
    print("ZIPs: $zips");
}

void main() {
    test1();
    test2();
    /*
    ZipDBBench1().report();
    ZipDBBench2().report();
    assert(ZipTestResults.zipSingle != null);
    assert(ZipTestResults.zipSingle.isNotEmpty);
    assert(ZipTestResults.zipSingle[0].zip == 94305);
    print("${ZipTestResults.zipSingle}");
    */
}
