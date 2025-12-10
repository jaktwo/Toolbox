// @file:   module.jai
// @author: jak2 <jak2@clover-work.shop>
//
// from the poet to the lover, the support of clover
//

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

generate_enum_entries_from_filenames :: (files_list: []string, generate_indices: bool=true) -> string {
    enum_as_string_string_builder: String_Builder;

    for files_list {
		current_file_name_without_path := path_filename(it);
		current_file_name_without_path_and_extension := path_strip_extension(current_file_name_without_path);
		
		for current_file_name_without_path_and_extension append(*enum_as_string_string_builder, to_upper(it));
		
		if generate_indices then append(*enum_as_string_string_builder, tprint(" :: %", it_index));
        append(*enum_as_string_string_builder, ";\n");
    }

    return builder_to_string(*enum_as_string_string_builder);
}

enum_member_count :: (enumerator: Type) -> int {
	return enum_values_as_s64(enumerator).count.(int);
}

// based on the implementation of the Language beta Discord user "bloeys"
default_array_value :: (value: $T, count: int) -> string {
    if count <= 0 return ".[];";
    
    info := type_info(type_of(value));
    
    enum_dot: string;
    if info.type == .ENUM then enum_dot = ".";
    
    builder: String_Builder;
    
    print(*builder, ".[%1%", enum_dot, value);
    for 1..count - 1 print(*builder, ",%1%", enum_dot, value);
    print(*builder, "];");

    return builder_to_string(*builder);
}

pack_16bit_integers_to_u32 :: ( lower : $T, upper : $V ) -> u32 #expand {
    #assert(type_info(T) == type_info(u16) || type_info(T) == type_info(s16));
    #assert(type_info(V) == type_info(u16) || type_info(V) == type_info(s16));

    as_u16_lower := ((*lower).(*u16)).*;
    as_u16_upper := ((*upper).(*u16)).*;

    return ( 
        // Autocast to u16, then to u32 and pack into a single u32.
        (as_u16_lower).(u32) | ( (as_u16_upper).(u32) << 16 ));
}

MASK    : u32 : 0xFFFF;
SIXTEEN : u32 : 16; 

unpack_lower_s16_from_u32 :: ( packed : u32 ) -> s16 #expand { return ((packed << 16) >> 16).(s16);  }
unpack_lower_u16_from_u32 :: ( packed : u32 ) -> u16 #expand { return (packed & 0xFFFF).(u16); }
unpack_upper_s16_from_u32 :: ( packed : u32 ) -> s16 #expand { return (packed  >> SIXTEEN).(s16); }
unpack_upper_u16_from_u32 :: ( packed : u32 ) -> s16 #expand { return ((packed >> SIXTEEN) & u32.{0xffff}).(u16); }

#scope_module

#load "platform/platform.jai";

#import "Basic";
#import "File";
#import "File_Utilities";
#import "String";
