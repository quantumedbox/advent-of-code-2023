extends MainLoop

func _initialize() -> void:
    var file = File.new()
    if file.open("input", File.READ) != OK:
        assert(false)
    var input = file.get_as_text()
    var result = 0
    for line in input.split("\n"):
        if line.empty(): continue
        var parts = line.substr(line.find(":") + 1).split("|")
        var winns = parts[0].split(" ")
        var value = 0
        for card in parts[1].split(" "):
            if not card.empty() and card in winns:
                value = max(1, value * 2)
        result += value
    file.close()
    print(result)

func _idle(_delta) -> bool:
    return true
