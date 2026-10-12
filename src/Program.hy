public class Program {
    public static int Main(string[] args) {
        if (System.Australis.Files.ApiVersion() != 1) { return 30; }
        string path = "/hello.txt";
        if (args.Length > 0) { path = args[0]; }
        System.Console.WriteLine("Australis File Inspector");
        System.Console.WriteLine(path);
        int kind = System.Australis.Files.StatKind(path);
        int status = System.Australis.Files.Status();
        if (status != 0) {
            System.Console.WriteLine("Stat error:");
            System.Console.WriteLine(status);
            return status;
        }
        System.Console.WriteLine("Kind:");
        System.Console.WriteLine(kind);
        System.Console.WriteLine("Size in bytes:");
        System.Console.WriteLine(System.Australis.Files.StatSize(path));
        long objectId = System.Australis.Files.StatId(path);
        if (objectId == 0) { System.Console.WriteLine("Object ID: unavailable"); }
        else {
            System.Console.WriteLine("Object ID:");
            System.Console.WriteLine(objectId);
        }
        int flags = System.Australis.Files.StatTimeFlags(path);
        if (flags % 2 != 0) {
            System.Console.WriteLine("Created (Unix seconds):");
            System.Console.WriteLine(System.Australis.Files.StatCreated(path));
        } else { System.Console.WriteLine("Created: unavailable"); }
        if (flags / 2 != 0) {
            System.Console.WriteLine("Modified (Unix seconds):");
            System.Console.WriteLine(System.Australis.Files.StatModified(path));
        } else { System.Console.WriteLine("Modified: unavailable"); }

        if (kind == 2) {
            int entries = System.Australis.Files.DirectoryCount(path);
            if (entries < 0) { return System.Australis.Files.Status(); }
            System.Console.WriteLine("Directory entries:");
            int i = 0;
            while (i < entries) {
                int length = System.Australis.Files.DirectoryName(path, i);
                if (length < 0) { return System.Australis.Files.Status(); }
                System.Australis.Files.WriteResult();
                System.Console.WriteLine();
                i = i + 1;
            }
            if (System.Australis.Files.DirectoryName(path, entries) != -1 ||
                System.Australis.Files.Status() != 5) { return 31; }
            return 0;
        }
        if (kind != 1) { return 32; }
        int opened = System.Australis.Files.OpenRead(path);
        if (opened != 0) { return opened; }
        int read = System.Australis.Files.ReadChecked(32);
        if (read < 0) { return System.Australis.Files.Status(); }
        if (read >= 4 && System.Australis.Files.ResultByte(0) == 65 &&
            System.Australis.Files.ResultByte(1) == 85 &&
            System.Australis.Files.ResultByte(2) == 69 &&
            System.Australis.Files.ResultByte(3) == 88) {
            if (read < 32) {
                System.Console.WriteLine("Incomplete AUEX header");
            } else {
                System.Console.WriteLine("Format: AUEX");
                System.Console.WriteLine("Target: Australis bytecode");
                System.Console.WriteLine("Format version:");
                System.Console.WriteLine(System.Australis.Files.ResultByte(4));
                System.Console.WriteLine("Header bytes:");
                System.Console.WriteLine(System.Australis.Files.ResultByte(5));
                System.Console.WriteLine("Code bytes:");
                System.Console.WriteLine(System.Australis.Files.ResultU32(8));
                System.Console.WriteLine("Initialized data bytes:");
                System.Console.WriteLine(System.Australis.Files.ResultU32(12));
                System.Console.WriteLine("Data capacity:");
                System.Console.WriteLine(System.Australis.Files.ResultU32(16));
                System.Console.WriteLine("Entry offset:");
                System.Console.WriteLine(System.Australis.Files.ResultU32(20));
                System.Console.WriteLine("Stored code CRC32:");
                System.Console.WriteLine(System.Australis.Files.ResultU32(24));
                System.Console.WriteLine("Stored data CRC32:");
                System.Console.WriteLine(System.Australis.Files.ResultU32(28));
            }
        } else if (read > 0) {
            System.Console.WriteLine("First bytes:");
            System.Australis.Files.WriteResult();
            System.Console.WriteLine();
        }
        System.Australis.Files.CloseChecked();
        return 0;
    }
}
