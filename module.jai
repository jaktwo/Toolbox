get_game_user_data_path :: (game_title: string) -> bool, string {
    c_string_path := getenv(to_c_string(user_path));

    path := to_string(c_string_path, strlen(c_string_path));

    builder: String_Builder;
    
    append(*builder, path);
    append(*builder, "\\");
    append(*builder, game_title);
    append(*builder, "\\");
    
    return true, builder_to_string(*builder);
}

// file extension should have the ".extension" format
get_file_names_of_type :: (file_extension: string, folder_path: string) -> []string {
    file_extension_corrector_string_builder: String_Builder;

    // correcting the extension if it does not start with a dot
    if file_extension.data.*.(u8) != #char "." then append(*file_extension_corrector_string_builder, ".");

    append(*file_extension_corrector_string_builder, file_extension);

    correct_file_extension := builder_to_string(*file_extension_corrector_string_builder);

    file_paths_list := file_list(folder_path);

    file_names_of_extension: [..]string;
    for file_paths_list if ends_with(it, correct_file_extension) then array_add(*file_names_of_extension, it);

    return file_names_of_extension;
}

read_entire_files_in_list_as_strings :: (files_list: []string) -> []string {
    loaded_files: [..]string;
    
    for files_list array_add(*loaded_files, read_entire_file(it));

    return loaded_files;
}

generate_enum_entries_from_filenames :: (files_list: []string) -> string {
    enum_as_string_string_builder: String_Builder;

    for files_list {
		current_file_name_without_path := path_filename(it);
		current_file_name_without_path_and_extension := path_strip_extension(current_file_name_without_path);
		
		for current_file_name_without_path_and_extension append(*enum_as_string_string_builder, to_upper(it));
		
		append(*enum_as_string_string_builder, tprint(" :: %;\n", it_index));
    }

    return builder_to_string(*enum_as_string_string_builder);
}

#scope_module

#load "platform/platform.jai";

#import "Basic";
#import "File";
#import "File_Utilities";
#import "String";
