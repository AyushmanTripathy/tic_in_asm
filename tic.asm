  org 0x7c00
  mov bp, 0x8000
  mov sp, bp

  ; current player
  mov cl, 'X'
  mov ch, 'O'

game_loop:
  call print_state
  call check_for_winner
  call check_for_draw

  ; printing input prompt
  mov ah, 0x0e
  mov al, cl
  int 0x10
  mov di, next_move_prompt
  call print_buffer

  call read_input
  jmp game_loop

game_over:
  mov di, game_ended_message
  call print_buffer
  jmp end

check_for_winner:
  ; horizontals
  mov si, 1
  mov di, 0
  call check_triplets
  mov di, 3
  call check_triplets
  mov di, 6
  call check_triplets

  ; verticals
  mov si, 3
  mov di, 0
  call check_triplets
  mov di, 1
  call check_triplets
  mov di, 2
  call check_triplets

  ; diagonals
  mov si, 4
  mov di, 0
  call check_triplets
  mov si, 2
  mov di, 2
  call check_triplets

  ret

  ; di -> start
  ; si -> step
check_triplets:
  mov bx, state_buffer
  add bx, di
  cmp [bx], ch
  jne triplet_not_same

  add bx, si
  cmp [bx], ch
  jne triplet_not_same

  add bx, si
  cmp [bx], ch
  jne triplet_not_same

  ; game won
  mov ah, 0x0e
  mov al, ch
  int 0x10
  mov di, game_won_message
  call print_buffer

  jmp game_over
triplet_not_same:
  ret

check_for_draw:
  mov bx, state_buffer
check_for_draw_loop:
  mov al, [bx]
  inc bx
  cmp al, '-'
  je check_for_draw_end
  cmp al, 0
  jne check_for_draw_loop

  ; game is draw
  mov di, game_draw_message
  call print_buffer
  jmp game_over

check_for_draw_end:
  ret

read_input:
  ; taking user input
  mov ah, 0
  int 0x16
  mov ah, 0x0e
  int 0x10

  mov di, newline
  call print_buffer

  ; checking user input
  cmp al, 49
  jl is_invalid_input
  cmp al, 57
  jg is_invalid_input

  mov ah, 0
  sub al, 49
  mov bx, state_buffer
  add bx, ax

  mov al, '-'
  cmp [bx], al
  jne is_preoccupied

  mov [bx], cl

  ; swap player
  cmp cl, 'X'
  je is_currently_x
is_currently_o:
  mov cl, 'X'
  mov ch, 'O'
  ret
is_currently_x:
  mov cl, 'O'
  mov ch, 'X'
  ret

is_invalid_input:
  mov di, invalid_input_message
  call print_buffer
  ret
is_preoccupied:
  mov di, preoccupied_message
  call print_buffer
  ret

print_state:
  pusha
  mov bx, state_buffer
  mov cl, '1' ; cell count
  mov ch, 0 ; column count
  mov ah, 0x0e

  mov di, horizontal_game_border
  call print_buffer

print_state_loop:
  mov al, [bx]

  cmp al, '-'
  jne if_non_empty_cell
  mov al, cl
if_non_empty_cell:
  int 0x10
  mov al, ' ' 
  int 0x10

  inc bx
  inc ch
  inc cl

  cmp ch, 3
  jne print_state_loop

  mov ch, 0

  call print_buffer

  ; char after 9
  cmp cl, ':'
  jne print_state_loop
print_state_end:
  mov di, newline
  call print_buffer
  popa
  ret

  ; printing buffer
print_buffer:
  pusha
  mov ah, 0x0e
print_buffer_loop:
  mov al, [di]

  cmp al, 0
  je print_buffer_end

  int 0x10
  inc di
  jmp print_buffer_loop
print_buffer_end:
  popa
  ret

game_draw_message:
  db "It's a Draw!", 13, 10, 0
game_won_message:
  db " Won!", 13, 10, 0
game_ended_message:
  db "Game ended", 0
preoccupied_message:
  db "Already occpuied, Select someother cell.", 13, 10, 0
invalid_input_message:
  db "Invalid input, Provide a cell number.", 0
newline:
  db 13, 10, 0
state_buffer:
  db "---------", 0
horizontal_game_border:
  db 13, 10, "         ", 13, 10, ' ', 0
next_move_prompt:
  db "'s turn: ", 0
end_message:
  db 13, 10, "Program ended", 0

end:
  mov di, end_message
  call print_buffer
  jmp $
  times 510-($-$$) db 0
  db 0x55, 0xaa
