// @file:   linux.jai
// @author: jak2 <jak2@clover-work.shop>
//
// from the poet to the lover, the support of clover
//

libc :: #library,system "libc";

user_path := "HOME";

// @ note <backspc3>: We need this symbol for linux too, since it isnt
//                    implemented yet, we use a placeholder function.
free_console :: () -> bool { return true; }