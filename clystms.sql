create table Coach (
    CoachId  INT UNSIGNED AUTO_INCREMENT,
    LName    VARCHAR(30) NOT NULL,
    FName    VARCHAR(30) NOT NULL,
    Phone    VARCHAR(12) NOT NULL,
    EMail    VARCHAR(60) NOT NULL,
    CONSTRAINT Coach_pk PRIMARY KEY(CoachId)
    );

create table Caretaker(
    CT_Id    int unsigned auto_increment,
    LName    varchar(30) not null,
    FName    varchar(30) not null,
    Phone    varchar(12) not null,
    EMail    varchar(60) not null,
    constraint Caretaker_pk primary key(CT_Id)
    );
	
create table Swimmer(
    SwimmerID        int unsigned auto_increment,
    LName    varchar(30) not null,
    FName    varchar(30) not null,
    Phone    varchar(12) not null,
    EMail    varchar(60) not null,
    JoinTime date not null,
    CurrentLevelId   int unsigned not null,
    Main_CT_Id       int unsigned not null,
    Main_CT_Since    date not null,
    PRIMARY KEY(SwimmerID)
	);
	
ALTER TABLE Swimmer
ADD FOREIGN KEY (Main_CT_Id)
REFERENCES Caretaker(CT_Id);
ALTER TABLE swimmer
ADD FOREIGN KEY (CurrentLevelId)
REFERENCES level(LevelId);


create table OtherCaretaker(
    OC_Id    int unsigned auto_increment,
    SwimmerId        int unsigned not null,
    CT_Id    int unsigned not null,
    Since    date not null,
    constraint       OtherCaretaker_pk primary key(OC_Id),
    constraint       OtherCaretaker_ck_1 unique(SwimmerId, CT_Id)
    );

create table Level(
	LevelId int unsigned auto_increment,
	Level int unsigned not null,
	Description varchar(250),
	constraint Level_pk primary key(LevelId),
	constraint Level_ck_1 unique(Level)
);

create table LevelHistory(
    LH_Id   int unsigned auto_increment,
    SwimmerId   int unsigned not null,
    LevelId int unsigned not null,
    StartDate       date not null,
    Comment varchar(250),
    constraint  LevelHistory_pk primary key(LH_Id),
    constraint  LevelHistory_ck_1   unique(SwimmerId, LevelId),
    constraint  LevelHistory_swimmer_fk foreign key(SwimmerId) references Swimmer(SwimmerId),
    constraint  LevelHistory_level_fk foreign key(LevelId) references Level(LevelId)
    );

create table Venue(
    VenueId int unsigned auto_increment,
    Name    varchar(60) not null,
    Address varchar(60) not null,
    City    varchar(30) not null,
    State   varchar(20) not null,
    Zipcode int(5) unsigned not null,
    Phone   varchar(12) not null,
    constraint Venue_pk primary key(VenueId),
    constraint Venue_ck_1 unique(Address, City, State, Zipcode)
    );

create table Meet(
	MeetId int unsigned auto_increment,
	Title varchar(60)	not null,
	Date date not null,
	StartTime time not null,
	EndTime time not null,
	VenueId int unsigned not null,
	CoachId int unsigned not null,
	constraint Meet_pk primary key(MeetId),
	constraint Meet_coach_fk foreign key(CoachId)
	references Coach(CoachId),
	constraint Meet_venue_fk foreign key(VenueId)
	references Venue(VenueId)
);

create table Event(
	EventId int unsigned auto_increment,
	Title varchar(60) not null,
	StartTime time not null,
	EndTime time not null,
	MeetId int unsigned not null,
	LevelId int unsigned not null,
	constraint Event_pk primary key(EventId),
	constraint Event_meet_fk foreign key(MeetId)
	references Meet(MeetId),
	constraint Event_level_fk foreign key(LevelId)
	references Level(LevelId)
);

create table Participation(
    PartId int unsigned auto_increment,
    SwimmerId int unsigned not null,
    EventId int unsigned not null,
    Committed bool,
    CommitTime time,
    Participated bool,
    Result time,
    Comment varchar(250),
    CommentCoachId int unsigned,
    constraint Part_pk primary key(PartId),
    constraint Part_ck_1 unique(SwimmerId, EventId),
    constraint Part_swimmer_fk foreign key(SwimmerId)
    references Swimmer(SwimmerId),
    constraint Part_coach_fk foreign key(CommentCoachId)
    references Coach(CoachId),
    constraint Part_event_fk foreign key(EventId)
    references Event(EventId)
    );

create table V_TaskList(
	VTL_Id int unsigned auto_increment,
	MeetId int unsigned not null,
	Required bool not null,
	Description varchar(250) not null,
	Penalty varchar(250),
	PenaltyAmt varchar(12),
	constraint VTL_pk primary key(VTL_Id),
	constraint VTL_ck_1 unique(MeetId),
	constraint VTL_meet_fk foreign key(MeetId)
	references Meet(MeetId)
);

create table V_Task(
	VT_Id int unsigned auto_increment,
	VTL_Id int unsigned not null,
	Name varchar(30) not null,
	Comment varchar(250),
	Num_V int unsigned not null default '1',
	constraint VT_pk primary key(VT_Id),
	constraint VT_ck_1 unique(VTL_Id, Name),
	constraint VT_vtlid_fk foreign key(VTL_Id)
	references V_TaskList(VTL_Id)
);

create table Commitment(
	CommitmentId int unsigned auto_increment,
	CT_Id int unsigned not null,
	VT_Id int unsigned not null,
	CommitTime time not null,
	Rescinded bool,
	RescindTime timestamp,
	CarriedOut bool,
	Comment varchar(250),
	CommentCoachId int unsigned,
	constraint Commitment_pk primary key(CommitmentId),
	constraint Commitment_ck_1 unique(CT_Id, VT_Id),
	constraint Commitment_ct_fk foreign key(CT_Id)
	references Caretaker(CT_Id),
	constraint Commitment_vt_fk foreign key(VT_Id)
	references V_Task(VT_Id),
	constraint Commitment_coach_fk foreign key(CommentCoachId)
	references Coach(CoachId)
);
