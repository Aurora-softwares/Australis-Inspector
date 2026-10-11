public class Program {
    public static int Main(string[] args) {
        System.Console.WriteLine("Australis File Inspector");
        System.Console.WriteLine("/hello.txt");
        int kind = System.Australis.Files.StatKind("/hello.txt");
        int status = System.Australis.Files.Status();
        if (status != 0) {
            System.Console.WriteLine("Stat error:");
            System.Console.WriteLine(status);
            return status;
        }
        System.Console.WriteLine("Kind:");
        System.Console.WriteLine(kind);
        System.Console.WriteLine("Size in bytes:");
        System.Console.WriteLine(System.Australis.Files.StatSize("/hello.txt"));
        System.Console.WriteLine("Object ID (0 if unavailable):");
        System.Console.WriteLine(System.Australis.Files.StatId("/hello.txt"));
        int flags = System.Australis.Files.StatTimeFlags("/hello.txt");
        System.Console.WriteLine("Time flags:");
        System.Console.WriteLine(flags);
        if (flags % 2 != 0) {
            System.Console.WriteLine("Created (Unix seconds):");
            System.Console.WriteLine(System.Australis.Files.StatCreated("/hello.txt"));
        }
        if (flags / 2 != 0) {
            System.Console.WriteLine("Modified (Unix seconds):");
            System.Console.WriteLine(System.Australis.Files.StatModified("/hello.txt"));
        }
        int entries = System.Australis.Files.DirectoryCount("/");
        if (entries >= 0) {
            System.Console.WriteLine("Root entries:");
            int i = 0;
            while (i < entries) {
                int length = System.Australis.Files.DirectoryName("/", i);
                if (length > 0) {
                    System.Australis.Files.WriteResult();
                    System.Console.WriteLine();
                }
                i = i + 1;
            }
        }
        int opened = System.Australis.Files.OpenRead("/hello.txt");
        if (opened == 0) {
            int read = System.Australis.Files.ReadChecked(16);
            if (read > 0) {
                System.Console.WriteLine("First bytes:");
                System.Australis.Files.WriteResult();
                System.Console.WriteLine();
            }
            System.Australis.Files.CloseChecked();
        }
        return 0;
    }
}
