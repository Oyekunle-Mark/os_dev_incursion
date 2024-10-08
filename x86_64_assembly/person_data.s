.section .data

# declare the people and num_people label as global so they are
# accessible from other files
.globl people, num_people
# the number of people
num_people:
	.quad (end_people - people) / PERSON_RECORD_SIZE
# person structure as array of quad words
# person structures arranged in succession in memory
people:
	.quad 200, 2, 74, 20
	.quad 280, 2, 72, 44
	.quad 150, 1, 68, 30
	.quad 250, 3, 75, 24
	.quad 250, 2, 70, 11
	.quad 180, 5, 69, 65
# end_people marks the end of the person structures
# used to find size of all person records
end_people:

# globals used for person record(structure) field access
.globl WEIGHT_OFFSET, HAIR_OFFSET, HEIGHT_OFFSET, AGE_OFFSET
# constants for offset of fields in the person record
.equ WEIGHT_OFFSET, 0
.equ HAIR_OFFSET, WEIGHT_OFFSET + 8
.equ HEIGHT_OFFSET, HAIR_OFFSET + 8
.equ AGE_OFFSET, HEIGHT_OFFSET + 8
# the size of the person record
.globl PERSON_RECORD_SIZE
.equ PERSON_RECORD_SIZE, 32
