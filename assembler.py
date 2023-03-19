import sys

opcodes = {
    "lw": "000",
    "sw": "001",
    "bez": "010",
    "xor": "011",
    "sll": "100",
    "and": "101",
    "or": "110",
    "add": "111"
}

file = open(sys.argv[1])
output_file = sys.argv[2]
output = open(output_file, "w")

for line in file:
    machCode = ""
    instruction = line.split(" ")
    
    operation = instruction[0].lower()
    if operation not in opcodes:
        continue
    operand1 = instruction[1]
    operand2 = instruction[2]
    
    machCode += opcodes[operation]
    
    machCode += "{:03b}".format(int(operand1[1]))
    
    if (operand2[0] == "R"):
        machCode += "{:03b}\n".format(int(operand2[1]))
    else:
        machCode += "{:03b}\n".format(int(operand2))
    output.write(machCode)
    
file.close()
output.close()
    #add R4, R5