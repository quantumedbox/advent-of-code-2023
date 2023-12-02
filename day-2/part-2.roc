app "aoc-day-2-part-1"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.6.0/QOQW08n38nHHrVVkJNiPIjzjvbR3iMjXeFY5w1aT46w.tar.br" }
    imports [pf.Stdout, pf.Stderr, pf.File, pf.Path, pf.Task]
    provides [main] to pf

main =
    program |> Task.onErr handleErr

program =
    input <- Path.fromStr "input" |> File.readUtf8 |> Task.await
    {} <- Stdout.line (Num.toStr (countIds input)) |> Task.await
    Task.ok {}

countIds = \in ->
    Str.split in "\n"
    |> List.walk 0 processLine

processLine = \state, line ->
    when Str.splitFirst line ":" is
        Ok { after, before } -> state + (evalGamePart after)
        _ -> state

evalGamePart = \part ->
    Str.split part ";"
    |> List.map \str -> Str.split str ","
    |> List.walk { red: 0, green: 0, blue: 0 } \state, throw ->
        List.walk throw state \innerstate, color ->
            when Str.split (Str.trim color) " " is
                [n, "red"] -> when Str.toU32 n is
                    Ok num -> { innerstate & red: if num > state.red then num else state.red }
                    Err InvalidNumStr -> crash "Invalid input"
                [n, "green"] -> when Str.toU32 n is
                    Ok num -> { innerstate & green: if num > state.green then num else state.green }
                    Err InvalidNumStr -> crash "Invalid input"
                [n, "blue"] -> when Str.toU32 n is
                    Ok num -> { innerstate & blue: if num > state.blue then num else state.blue }
                    Err InvalidNumStr -> crash "Invalid input"
                _ -> crash "Invalid input"
    |> \result ->
        result.red * result.green * result.blue

handleErr = \err ->
    when err is
        FileReadErr path _ -> Stderr.line "Error reading \(Path.display path)"
        FileReadUtf8Err path _ -> Stderr.line "Invalid unicode in \(Path.display path)"
