% Copyright

implement main
    open core, file, stdio

domains
    scholoarship = scholarship_student; not_scholarship_student.
    mark = excellent; good; bad.

class facts - students
    s : (real Sum) single.
    s2 : (real Sum) single.
    student : (integer Student_ID, string Student_Name, scholoarship Scholoarship).
    group : (integer Group_ID, string Direction, real Year, string Group_Name).
    country : (string Country, integer Student_ID).
    curator : (integer Group_ID, integer Student_ID).
    where_studies : (integer Student_ID, integer Group_ID).
    graduation_mark : (integer Student_ID, mark Mark).

class predicates
    reconsult : (string FileName).
    curators_list : (string Student_Name [out], string Group) nondeterm.
    graduation_mark_list : (string Student_Name, mark Mark [out]) nondeterm.
    studentInfo_list : (string Student_Name [out], string Country [out], string Group_Name [out], scholoarship Scholoarship [out]) nondeterm.
    total_students_from_a_group : (string Group_Name) nondeterm.
    total_students_from_a_country : (string Country) nondeterm.

clauses
    s(0).
    s2(0).
    reconsult(FileName) :-
        retractFactDb(students),
        consult(FileName, students).

    curators_list(Student_Name, Group_Name) :-
        group(Group_ID, _, _, Group_Name),
        curator(Group_ID, Student_ID),
        student(Student_ID, Student_Name, _).

    graduation_mark_list(Student_Name, Mark) :-
        student(Student_ID, Student_Name, _),
        graduation_mark(Student_ID, Mark).

    studentInfo_list(Student_Name, Country, Group_Name, Scholoarship) :-
        student(Student_ID, Student_Name, Scholoarship),
        country(Country, Student_ID),
        where_studies(Student_ID, Group_ID),
        group(Group_ID, _, _, Group_Name).

    total_students_from_a_group(Group_Name) :-
        group(Group_ID, _, _, Group_Name),
        where_studies(Student_ID, Group_ID),
        student(Student_ID, _, _),
        s(Sum),
        asserta(s(Sum + 1)),
        fail.

    total_students_from_a_group(Group_Name) :-
        s(Sum),
        group(_, _, _, Group_Name),
        write("\nthere is: ", Sum, " students study in ", Group_Name, "\n").

    total_students_from_a_country(Country) :-
        country(Country, Student_ID),
        student(Student_ID, _, _),
        s2(Sum),
        asserta(s2(Sum + 1)),
        fail.
    total_students_from_a_country(Country) :-
        s2(Sum),
        country(Country, _),
        write("\nthere is: ", Sum, " students study from ", Country, "\n").

clauses
    run() :-
        console::init(),
        reconsult("..\\students.txt"),
        nl,
        fail.

    run() :-
        studentInfo_list(X, Y, Z, V),
        write("The student: ", X, " is from ", Y, " and studies in ", Z, " & he is ", V, ".\n"),
        fail.

    run() :-
        write("\nPlease enter the name of the group, to show how many students study in this group: "),
        Z = readLine(),
        total_students_from_a_group(Z),
        fail.

    run() :-
        write("\nPlease enter the name of the country, to show how many students came from that country: "),
        V = readLine(),
        total_students_from_a_country(V),
        fail.

    run() :-
        write("\nPlease enter student's name to check his graduation's mark: "),
        X = readLine(),
        graduation_mark_list(X, Y),
        write("\nthe student ", X, " has graduated with:", Y, " mark"),
        fail.

    run() :-
        write("\nEnter name of the group to show its curators: "),
        Y = readLine(),
        curators_list(X, Y),
        write("\n", X, " is the curator of ", Y),
        fail.

    run() :-
        nl.

end implement main

goal
    mainExe::run(main::run).
