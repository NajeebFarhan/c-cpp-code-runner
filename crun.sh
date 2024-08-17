crun() {
    if [ -z "$1" ]; then
        echo "Usage: run_c_program <source-file.c/cpp> [args...]"
        return 1
    fi

    # Get the file name and extension
    local fileName="$1"
    shift
    local args=("$@")

    if [ ! -f "$fileName" ]; then
        echo "File $fileName does not exist."
        return 1
    fi

    local fileExtension="${fileName##*.}"
    local baseName="${fileName%.*}"
    local exeName="$baseName.out"

    # Compile the C or C++ program
    if [ "$fileExtension" == "c" ]; then
        clang "$fileName" -o "$exeName"
    elif [ "$fileExtension" == "cpp" ]; then
        clang++ "$fileName" -o "$exeName"
    else
        echo "File must have a .c or .cpp extension."
        return 1
    fi

    local fileExtension="${fileName##*.}"
    local baseName="${fileName%.*}"
    local exeName="$baseName.out"

    # Compile the C or C++ program
    if [ "$fileExtension" == "c" ]; then
        clang "$fileName" -o "$exeName"
    elif [ "$fileExtension" == "cpp" ]; then
        clang++ "$fileName" -o "$exeName"
    else
        echo "File must have a .c or .cpp extension."
        return 1
    fi

    # Check if the compilation was successful
    if [ $? -ne 0 ]; then
        echo "Compilation failed."
        return 1
    fi

    # Run the executable with the provided arguments
    ./"$exeName" "${args[@]}"

    # Remove the executable
    rm ./"$exeName"
}
