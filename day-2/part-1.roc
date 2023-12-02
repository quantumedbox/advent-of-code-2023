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
        Ok { after, before } if checkGamePart after -> state + (parseIdPart before)
        _ -> state

parseIdPart = \part ->
    when Str.splitLast part " " is
        Ok { after, before } -> when Str.toU32 after is
            Ok num -> num
            Err InvalidNumStr -> crash "Invalid input"
        Err NotFound -> crash "Invalid input"

boolToStr = \bool ->
    if bool then
        "true"
    else "false"

checkGamePart = \part ->
    Str.split part ";"
    |> List.map \str -> Str.split str ","
    |> List.all \throw ->
        List.all throw \color ->
            when Str.split (Str.trim color) " " is
                [n, "red"] -> when Str.toU32 n is
                    Ok num -> num <= 12
                    Err InvalidNumStr -> crash "Invalid input"
                [n, "green"] -> when Str.toU32 n is
                    Ok num -> num <= 13
                    Err InvalidNumStr -> crash "Invalid input"
                [n, "blue"] -> when Str.toU32 n is
                    Ok num -> num <= 14
                    Err InvalidNumStr -> crash "Invalid input"
                _ -> crash "Invalid input"

handleErr = \err ->
    when err is
        FileReadErr path _ -> Stderr.line "Error reading \(Path.display path)"
        FileReadUtf8Err path _ -> Stderr.line "Invalid unicode in \(Path.display path)"
