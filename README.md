# SwiftCodingWork
Currently implements a UPC barcode scanner (using the iDevice camera) that interacts with a C#.NET web service
to lookup descriptions of each product scanned, either cached in a SQL Server Database or pulled from a public lookup web service.  During the time that the product lookup descriptions are taking place, a status/progress message sequence is displayed.  The status message implementation is generic and implemented in the StatusMessage class.
