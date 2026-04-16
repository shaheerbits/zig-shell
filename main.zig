//! Copyright @ Shaheer Shaikh (2026)
//! Zig Shell

const std = @import("std");
const ArrayList = std.ArrayList;
const Writer = std.Io.Writer;
const WriterFailed = Writer.Error.WriteFailed;

pub fn main() !void {
    // Buffered stdout writer for efficient printing
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const zout = &stdout_writer.interface;

    // Buffered stdin reader for user input
    var stdin_buffer: [1024]u8 = undefined;
    var stdin_reader = std.fs.File.stdin().reader(&stdin_buffer);
    const zin = &stdin_reader.interface;

    const allocator = std.heap.page_allocator;

    // Main REPL (Read → Evaluate → Print → Loop)
    while (true) {
        try zout.writeAll("shaheer's zig shell> ");
        try zout.flush();

        // Read input until newline (Enter key)
        const input = try zin.takeDelimiter('\n');

        if (input) |value| {
            // Remove Windows line endings (\r\n)
            const trimmed = std.mem.trim(u8, value, "\r\n");

            if (trimmed.len == 0) continue;

            // Built-in: exit (terminates shell)
            if (std.mem.eql(u8, trimmed, "exit")) {
                try zout.writeAll("(shell exits)");
                try zout.flush();
                break;
            }

            // Built-in: pwd (print current directory)
            if (std.mem.eql(u8, trimmed, "pwd")) {
                const cwd = try std.process.getCwdAlloc(allocator);
                defer allocator.free(cwd);

                try zout.print("{s}\n", .{cwd});
                try zout.flush();
                continue;
            }

            // Tokenize input into command + arguments
            var tokens: ArrayList([]const u8) = .empty;
            defer tokens.deinit(allocator);

            var args = std.mem.splitScalar(u8, trimmed, ' ');

            while (args.next()) |token| {
                if (token.len == 0) continue;
                try tokens.append(allocator, token);
            }

            if (tokens.items.len == 0) continue;

            const cmd = tokens.items[0];

            // Built-in: cd (must change directory in current process)
            if (std.mem.eql(u8, cmd, "cd")) {
                if (tokens.items.len < 2) {
                    try zout.writeAll("cd: missing argument\n");
                    try zout.flush();
                    continue;
                }

                const path = tokens.items[1];

                std.process.changeCurDir(path) catch |err| {
                    try zout.print("cd error: {any}\n", .{err});
                    try zout.flush();
                };

                continue;
            }

            // Try executing command directly (for real executables)
            var child = std.process.Child.init(tokens.items, allocator);
            child.stdin_behavior = .Inherit;
            child.stdout_behavior = .Inherit;
            child.stderr_behavior = .Inherit;

            const result = child.spawnAndWait();

            if (result) |_| {
                // Command executed successfully
            } else |err| {
                // Fallback: use Windows shell for built-ins (echo, dir, etc.)
                if (err == error.FileNotFound) {
                    var fallback_args = [_][]const u8{
                        "cmd",
                        "/c",
                        trimmed,
                    };

                    var fallback = std.process.Child.init(&fallback_args, allocator);
                    fallback.stdin_behavior = .Inherit;
                    fallback.stdout_behavior = .Inherit;
                    fallback.stderr_behavior = .Inherit;

                    _ = try fallback.spawnAndWait();
                } else {
                    // Unexpected error → propagate
                    return err;
                }
            }
        }
    }
}
