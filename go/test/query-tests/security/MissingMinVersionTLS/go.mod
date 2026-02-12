module codeql-go-tests/query/MissingMinVersionTLS

// Using Go 1.15 (< 1.18) to test the case where both clients and servers
// default to TLS 1.0, so both should be flagged when MinVersion is not set
go 1.15
