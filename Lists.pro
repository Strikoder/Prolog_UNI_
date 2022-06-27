% Copyright

implement main
    open core, file, stdio

domains
    scholoarship = scholarship_student; not_scholarship_student.
    infos = infos(string Student_name, real Student_mark, scholoarship Student_status).

class facts - students
    student : (integer Student_ID, string Student_Name, scholoarship Scholoarship).
    group : (integer Group_ID, string Direction, real Year, string Group_Name).
    country : (string Country, integer Student_ID).
    where_studies : (integer Student_ID, integer Group_ID).
    graduation_mark : (integer Student_ID, real Mark).

class predicates
    length : (A*) -> integer N.
    sum : (real* List) -> real Sum.
    avg : (real* List) -> real Average determ.
    who_where_studies : (string Group_Name) -> string* Components determ.
    students_count : (string Group_Name) -> real N determ.
    students_info : (string Student_Group) -> infos* determ.
    write_infos : (infos* Marks_and_status).
    students_marks : (string Group_Name) -> real* determ.
    avg_mark : (string Group_Name) -> real Sum determ.

clauses
    write_infos(L) :-
        foreach infos(Student_name, Student_mark, Student_status) = list::getMember_nd(L) do
            writef("\t %s \t %f %s\t \n", Student_name, Student_mark, toString(Student_status))
        end foreach.

    length([]) = 0.
    length([_ | T]) = length(T) + 1.

    sum([]) = 0.
    sum([H | T]) = sum(T) + H.

    avg(L) = sum(L) / length(L) :-
        length(L) > 0.

    who_where_studies(Group_Name) = Stud :-
        group(Group_ID, _, _, Group_Name),
        !,
        Stud =
            [ Student_Name ||
                student(Student_ID, Student_Name, _),
                where_studies(Student_ID, Group_ID)
            ].

    students_count(Counter) = length(who_where_studies(Counter)).

    students_info(Group_Name) =
            [ infos(Student_name, Student_mark, Student_status) ||
                student(Student_ID, Student_Name, Student_status),
                graduation_mark(Student_ID, Student_mark),
                where_studies(Student_ID, Group_ID)
            ] :-
        group(Group_ID, _, _, Group_Name),
        !.

    students_marks(Group_Name) =
            [ Mark ||
                graduation_mark(Student_ID, Mark),
                student(Student_ID, _, _),
                where_studies(Student_ID, Group_ID)
            ] :-
        group(Group_ID, _, _, Group_Name),
        !.

    avg_mark(X) = avg(students_marks(X)).

clauses
    run() :-
        console::init(),
        file::consult("..\\Students(1).txt", students),
        nl,
        fail.
    run() :-
        write("Enter the group's name that you want to know how many students study in:\n "),
        X = readLine(),
        write("Number of students that are in this group are:\n "),
        write(students_count(X)),
        nl,
        fail.

    run() :-
        write("The students of this group are:\n "),
        X = readLine(),
        L = who_where_studies(X),
        write(L),
        nl,
        fail.

    run() :-
        write("Enter the name of the group to see the details about the marks: \n"),
        X = readLine(),
        write("The marks and the status of the students in that group are: \n"),
        nl,
        write_infos(students_info(X)),
        nl,
        fail.

    run() :-
        write("Enter the group that you want to see its marks:\n"),
        Y = readLine(),
        write(students_marks(Y)),
        write("\navg marks of students in the group: "),
        write(avg_mark(Y)),
        nl,
        fail.

    run().

end implement main

goal
    mainExe::run(main::run).
