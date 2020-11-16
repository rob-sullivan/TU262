
DROP TABLE Books
go

DROP TABLE Reserves
go

DROP TABLE Member
go

DROP TABLE StarsIn
go

DROP TABLE Performer
go

DROP TABLE Show
go

DROP TABLE Film
go

DROP TABLE Performance
go

CREATE TABLE Performance
( 
	ShowTime             integer  NOT NULL ,
	NumShowed            integer  NULL ,
	Status               char(18)  NULL ,
	CONSTRAINT XPKPerformance PRIMARY KEY  CLUSTERED (ShowTime ASC)
)
go

CREATE TABLE Film
( 
	FilmId               integer  NOT NULL ,
	Title                char(18)  NULL ,
	Kind                 char(18)  NULL ,
	FilmDate             char(18)  NULL ,
	Director             char(18)  NULL ,
	Distributor          char(18)  NULL ,
	RentalPrice          char(18)  NULL ,
	CONSTRAINT XPKFilm PRIMARY KEY  CLUSTERED (FilmId ASC)
)
go

CREATE TABLE Show
( 
	ShowTime             integer  NOT NULL ,
	FilmId               integer  NOT NULL ,
	CONSTRAINT XPKShow PRIMARY KEY  CLUSTERED (ShowTime ASC,FilmId ASC),
	CONSTRAINT R_3 FOREIGN KEY (ShowTime) REFERENCES Performance(ShowTime),
	CONSTRAINT R_4 FOREIGN KEY (FilmId) REFERENCES Film(FilmId)
)
go

CREATE TABLE Performer
( 
	PerformerId          char(18)  NOT NULL ,
	Name                 char(18)  NULL ,
	CONSTRAINT XPKPerformer PRIMARY KEY  CLUSTERED (PerformerId ASC)
)
go

CREATE TABLE StarsIn
( 
	FilmId               integer  NOT NULL ,
	PerformerId          char(18)  NOT NULL ,
	FilmRole             char(18)  NULL ,
	CONSTRAINT XPKStarsIn PRIMARY KEY  CLUSTERED (FilmId ASC,PerformerId ASC),
	CONSTRAINT R_28 FOREIGN KEY (PerformerId) REFERENCES Performer(PerformerId),
	CONSTRAINT R_29 FOREIGN KEY (FilmId) REFERENCES Film(FilmId)
)
go

CREATE TABLE Member
( 
	MemberId             integer  NOT NULL ,
	TotalRes             char(18)  NULL ,
	Address              char(18)  NULL ,
	Street               char(18)  NULL ,
	City                 char(18)  NULL ,
	CountryState         char(18)  NULL ,
	Children             char(18)  NULL ,
	CONSTRAINT XPKMember PRIMARY KEY  CLUSTERED (MemberId ASC)
)
go

CREATE TABLE Reserves
( 
	FilmId               integer  NOT NULL ,
	MemberId             integer  NOT NULL ,
	CONSTRAINT XPKReserves PRIMARY KEY  CLUSTERED (FilmId ASC,MemberId ASC),
	CONSTRAINT R_30 FOREIGN KEY (FilmId) REFERENCES Film(FilmId),
	CONSTRAINT R_31 FOREIGN KEY (MemberId) REFERENCES Member(MemberId)
)
go

CREATE TABLE Books
( 
	MemberId             integer  NOT NULL ,
	ShowTime             integer  NOT NULL ,
	ExtraCharge          char(18)  NULL ,
	CONSTRAINT XPKBooks PRIMARY KEY  CLUSTERED (MemberId ASC,ShowTime ASC),
	CONSTRAINT R_1 FOREIGN KEY (MemberId) REFERENCES Member(MemberId),
	CONSTRAINT R_2 FOREIGN KEY (ShowTime) REFERENCES Performance(ShowTime)
)
go
