
CREATE TABLE [Books]
( 
	[MemberId]           char(18)  NOT NULL ,
	[ShowTime]           char(18)  NOT NULL ,
	[ExtraCharge]        char(18)  NULL 
)
go

ALTER TABLE [Books]
	ADD CONSTRAINT [XPKBooks] PRIMARY KEY  CLUSTERED ([MemberId] ASC,[ShowTime] ASC)
go

CREATE TABLE [Film]
( 
	[FilmId]             char(18)  NOT NULL ,
	[Title]              char(18)  NULL ,
	[Kind]               char(18)  NULL ,
	[Date]               char(18)  NULL ,
	[Director]           char(18)  NULL ,
	[Distributor]        char(18)  NULL ,
	[RentalPrice]        char(18)  NULL 
)
go

ALTER TABLE [Film]
	ADD CONSTRAINT [XPKFilm] PRIMARY KEY  CLUSTERED ([FilmId] ASC)
go

CREATE TABLE [Film_StarsIn]
( 
	[FilmId]             char(18)  NOT NULL 
)
go

ALTER TABLE [Film_StarsIn]
	ADD CONSTRAINT [XPKFilm_StarsIn] PRIMARY KEY  CLUSTERED ([FilmId] ASC)
go

CREATE TABLE [Member]
( 
	[MemberId]           char(18)  NOT NULL ,
	[TotalRes]           char(18)  NULL ,
	[Address]            char(18)  NULL ,
	[Street]             char(18)  NULL ,
	[City]               char(18)  NULL ,
	[State]              char(18)  NULL ,
	[Children]           char(18)  NULL 
)
go

ALTER TABLE [Member]
	ADD CONSTRAINT [XPKMember] PRIMARY KEY  CLUSTERED ([MemberId] ASC)
go

CREATE TABLE [Member_Reserves]
( 
	[MemberId]           char(18)  NOT NULL 
)
go

ALTER TABLE [Member_Reserves]
	ADD CONSTRAINT [XPKMember_Reserves] PRIMARY KEY  CLUSTERED ([MemberId] ASC)
go

CREATE TABLE [Performance]
( 
	[ShowTime]           char(18)  NOT NULL ,
	[NumShowed]          char(18)  NULL ,
	[Status]             char(18)  NULL 
)
go

ALTER TABLE [Performance]
	ADD CONSTRAINT [XPKPerformance] PRIMARY KEY  CLUSTERED ([ShowTime] ASC)
go

CREATE TABLE [Performer]
( 
	[Name]               char(18)  NOT NULL 
)
go

ALTER TABLE [Performer]
	ADD CONSTRAINT [XPKPerformer] PRIMARY KEY  CLUSTERED ([Name] ASC)
go

CREATE TABLE [Performer_StarsIn]
( 
	[Name]               char(18)  NOT NULL 
)
go

ALTER TABLE [Performer_StarsIn]
	ADD CONSTRAINT [XPKPerformer_StarsIn] PRIMARY KEY  CLUSTERED ([Name] ASC)
go

CREATE TABLE [Show]
( 
	[ShowTime]           char(18)  NOT NULL ,
	[FilmId]             char(18)  NOT NULL 
)
go

ALTER TABLE [Show]
	ADD CONSTRAINT [XPKShow] PRIMARY KEY  CLUSTERED ([ShowTime] ASC,[FilmId] ASC)
go

CREATE TABLE [Show_Reserves]
( 
	[ShowTime]           char(18)  NOT NULL ,
	[FilmId]             char(18)  NOT NULL 
)
go

ALTER TABLE [Show_Reserves]
	ADD CONSTRAINT [XPKShow_Reserves] PRIMARY KEY  CLUSTERED ([ShowTime] ASC,[FilmId] ASC)
go

CREATE TABLE [StarsIn]
( 
	[Role]               char(18)  NULL 
)
go


ALTER TABLE [Books]
	ADD CONSTRAINT [R_1] FOREIGN KEY ([MemberId]) REFERENCES [Member]([MemberId])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Books]
	ADD CONSTRAINT [R_2] FOREIGN KEY ([ShowTime]) REFERENCES [Performance]([ShowTime])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Film_StarsIn]
	ADD CONSTRAINT [R_15] FOREIGN KEY ([FilmId]) REFERENCES [Film]([FilmId])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Member_Reserves]
	ADD CONSTRAINT [R_18] FOREIGN KEY ([MemberId]) REFERENCES [Member]([MemberId])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Performer_StarsIn]
	ADD CONSTRAINT [R_12] FOREIGN KEY ([Name]) REFERENCES [Performer]([Name])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Show]
	ADD CONSTRAINT [R_3] FOREIGN KEY ([ShowTime]) REFERENCES [Performance]([ShowTime])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Show]
	ADD CONSTRAINT [R_4] FOREIGN KEY ([FilmId]) REFERENCES [Film]([FilmId])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Show_Reserves]
	ADD CONSTRAINT [R_21] FOREIGN KEY ([ShowTime],[FilmId]) REFERENCES [Show]([ShowTime],[FilmId])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


CREATE TRIGGER tD_Books ON Books FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Books */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Performance  Books on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00025660", PARENT_OWNER="", PARENT_TABLE="Performance"
    CHILD_OWNER="", CHILD_TABLE="Books"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="ShowTime" */
    IF EXISTS (SELECT * FROM deleted,Performance
      WHERE
        /* %JoinFKPK(deleted,Performance," = "," AND") */
        deleted.ShowTime = Performance.ShowTime AND
        NOT EXISTS (
          SELECT * FROM Books
          WHERE
            /* %JoinFKPK(Books,Performance," = "," AND") */
            Books.ShowTime = Performance.ShowTime
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Books because Performance exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Member  Books on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Member"
    CHILD_OWNER="", CHILD_TABLE="Books"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="MemberId" */
    IF EXISTS (SELECT * FROM deleted,Member
      WHERE
        /* %JoinFKPK(deleted,Member," = "," AND") */
        deleted.MemberId = Member.MemberId AND
        NOT EXISTS (
          SELECT * FROM Books
          WHERE
            /* %JoinFKPK(Books,Member," = "," AND") */
            Books.MemberId = Member.MemberId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Books because Member exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Books ON Books FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Books */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insMemberId char(18), 
           @insShowTime char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Performance  Books on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00029a29", PARENT_OWNER="", PARENT_TABLE="Performance"
    CHILD_OWNER="", CHILD_TABLE="Books"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="ShowTime" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(ShowTime)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Performance
        WHERE
          /* %JoinFKPK(inserted,Performance) */
          inserted.ShowTime = Performance.ShowTime
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Books because Performance does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Member  Books on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Member"
    CHILD_OWNER="", CHILD_TABLE="Books"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="MemberId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(MemberId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Member
        WHERE
          /* %JoinFKPK(inserted,Member) */
          inserted.MemberId = Member.MemberId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Books because Member does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Film ON Film FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Film */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Film  Film_StarsIn on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0001d0c9", PARENT_OWNER="", PARENT_TABLE="Film"
    CHILD_OWNER="", CHILD_TABLE="Film_StarsIn"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="FilmId" */
    IF EXISTS (
      SELECT * FROM deleted,Film_StarsIn
      WHERE
        /*  %JoinFKPK(Film_StarsIn,deleted," = "," AND") */
        Film_StarsIn.FilmId = deleted.FilmId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Film because Film_StarsIn exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Film  Show on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Film"
    CHILD_OWNER="", CHILD_TABLE="Show"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="FilmId" */
    IF EXISTS (
      SELECT * FROM deleted,Show
      WHERE
        /*  %JoinFKPK(Show,deleted," = "," AND") */
        Show.FilmId = deleted.FilmId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Film because Show exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Film ON Film FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Film */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insFilmId char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Film  Film_StarsIn on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00020da4", PARENT_OWNER="", PARENT_TABLE="Film"
    CHILD_OWNER="", CHILD_TABLE="Film_StarsIn"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="FilmId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(FilmId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Film_StarsIn
      WHERE
        /*  %JoinFKPK(Film_StarsIn,deleted," = "," AND") */
        Film_StarsIn.FilmId = deleted.FilmId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Film because Film_StarsIn exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Film  Show on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Film"
    CHILD_OWNER="", CHILD_TABLE="Show"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="FilmId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(FilmId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Show
      WHERE
        /*  %JoinFKPK(Show,deleted," = "," AND") */
        Show.FilmId = deleted.FilmId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Film because Show exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Film_StarsIn ON Film_StarsIn FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Film_StarsIn */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Film  Film_StarsIn on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="000139a5", PARENT_OWNER="", PARENT_TABLE="Film"
    CHILD_OWNER="", CHILD_TABLE="Film_StarsIn"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="FilmId" */
    IF EXISTS (SELECT * FROM deleted,Film
      WHERE
        /* %JoinFKPK(deleted,Film," = "," AND") */
        deleted.FilmId = Film.FilmId AND
        NOT EXISTS (
          SELECT * FROM Film_StarsIn
          WHERE
            /* %JoinFKPK(Film_StarsIn,Film," = "," AND") */
            Film_StarsIn.FilmId = Film.FilmId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Film_StarsIn because Film exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Film_StarsIn ON Film_StarsIn FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Film_StarsIn */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insFilmId char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Film  Film_StarsIn on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0001611a", PARENT_OWNER="", PARENT_TABLE="Film"
    CHILD_OWNER="", CHILD_TABLE="Film_StarsIn"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="FilmId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(FilmId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Film
        WHERE
          /* %JoinFKPK(inserted,Film) */
          inserted.FilmId = Film.FilmId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Film_StarsIn because Film does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Member ON Member FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Member */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Member  Member_Reserves on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0001f05b", PARENT_OWNER="", PARENT_TABLE="Member"
    CHILD_OWNER="", CHILD_TABLE="Member_Reserves"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_18", FK_COLUMNS="MemberId" */
    IF EXISTS (
      SELECT * FROM deleted,Member_Reserves
      WHERE
        /*  %JoinFKPK(Member_Reserves,deleted," = "," AND") */
        Member_Reserves.MemberId = deleted.MemberId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Member because Member_Reserves exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Member  Books on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Member"
    CHILD_OWNER="", CHILD_TABLE="Books"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="MemberId" */
    IF EXISTS (
      SELECT * FROM deleted,Books
      WHERE
        /*  %JoinFKPK(Books,deleted," = "," AND") */
        Books.MemberId = deleted.MemberId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Member because Books exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Member ON Member FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Member */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insMemberId char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Member  Member_Reserves on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0002295c", PARENT_OWNER="", PARENT_TABLE="Member"
    CHILD_OWNER="", CHILD_TABLE="Member_Reserves"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_18", FK_COLUMNS="MemberId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(MemberId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Member_Reserves
      WHERE
        /*  %JoinFKPK(Member_Reserves,deleted," = "," AND") */
        Member_Reserves.MemberId = deleted.MemberId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Member because Member_Reserves exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Member  Books on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Member"
    CHILD_OWNER="", CHILD_TABLE="Books"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="MemberId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(MemberId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Books
      WHERE
        /*  %JoinFKPK(Books,deleted," = "," AND") */
        Books.MemberId = deleted.MemberId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Member because Books exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Member_Reserves ON Member_Reserves FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Member_Reserves */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Member  Member_Reserves on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="000142e8", PARENT_OWNER="", PARENT_TABLE="Member"
    CHILD_OWNER="", CHILD_TABLE="Member_Reserves"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_18", FK_COLUMNS="MemberId" */
    IF EXISTS (SELECT * FROM deleted,Member
      WHERE
        /* %JoinFKPK(deleted,Member," = "," AND") */
        deleted.MemberId = Member.MemberId AND
        NOT EXISTS (
          SELECT * FROM Member_Reserves
          WHERE
            /* %JoinFKPK(Member_Reserves,Member," = "," AND") */
            Member_Reserves.MemberId = Member.MemberId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Member_Reserves because Member exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Member_Reserves ON Member_Reserves FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Member_Reserves */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insMemberId char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Member  Member_Reserves on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00016236", PARENT_OWNER="", PARENT_TABLE="Member"
    CHILD_OWNER="", CHILD_TABLE="Member_Reserves"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_18", FK_COLUMNS="MemberId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(MemberId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Member
        WHERE
          /* %JoinFKPK(inserted,Member) */
          inserted.MemberId = Member.MemberId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Member_Reserves because Member does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Performance ON Performance FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Performance */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Performance  Show on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0001e557", PARENT_OWNER="", PARENT_TABLE="Performance"
    CHILD_OWNER="", CHILD_TABLE="Show"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="ShowTime" */
    IF EXISTS (
      SELECT * FROM deleted,Show
      WHERE
        /*  %JoinFKPK(Show,deleted," = "," AND") */
        Show.ShowTime = deleted.ShowTime
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Performance because Show exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Performance  Books on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Performance"
    CHILD_OWNER="", CHILD_TABLE="Books"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="ShowTime" */
    IF EXISTS (
      SELECT * FROM deleted,Books
      WHERE
        /*  %JoinFKPK(Books,deleted," = "," AND") */
        Books.ShowTime = deleted.ShowTime
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Performance because Books exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Performance ON Performance FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Performance */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insShowTime char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Performance  Show on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00022a56", PARENT_OWNER="", PARENT_TABLE="Performance"
    CHILD_OWNER="", CHILD_TABLE="Show"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="ShowTime" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ShowTime)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Show
      WHERE
        /*  %JoinFKPK(Show,deleted," = "," AND") */
        Show.ShowTime = deleted.ShowTime
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Performance because Show exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Performance  Books on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Performance"
    CHILD_OWNER="", CHILD_TABLE="Books"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="ShowTime" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ShowTime)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Books
      WHERE
        /*  %JoinFKPK(Books,deleted," = "," AND") */
        Books.ShowTime = deleted.ShowTime
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Performance because Books exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Performer ON Performer FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Performer */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Performer  Performer_StarsIn on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0001166a", PARENT_OWNER="", PARENT_TABLE="Performer"
    CHILD_OWNER="", CHILD_TABLE="Performer_StarsIn"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="Name" */
    IF EXISTS (
      SELECT * FROM deleted,Performer_StarsIn
      WHERE
        /*  %JoinFKPK(Performer_StarsIn,deleted," = "," AND") */
        Performer_StarsIn.Name = deleted.Name
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Performer because Performer_StarsIn exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Performer ON Performer FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Performer */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insName char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Performer  Performer_StarsIn on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00013df4", PARENT_OWNER="", PARENT_TABLE="Performer"
    CHILD_OWNER="", CHILD_TABLE="Performer_StarsIn"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="Name" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Name)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Performer_StarsIn
      WHERE
        /*  %JoinFKPK(Performer_StarsIn,deleted," = "," AND") */
        Performer_StarsIn.Name = deleted.Name
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Performer because Performer_StarsIn exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Performer_StarsIn ON Performer_StarsIn FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Performer_StarsIn */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Performer  Performer_StarsIn on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00015478", PARENT_OWNER="", PARENT_TABLE="Performer"
    CHILD_OWNER="", CHILD_TABLE="Performer_StarsIn"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="Name" */
    IF EXISTS (SELECT * FROM deleted,Performer
      WHERE
        /* %JoinFKPK(deleted,Performer," = "," AND") */
        deleted.Name = Performer.Name AND
        NOT EXISTS (
          SELECT * FROM Performer_StarsIn
          WHERE
            /* %JoinFKPK(Performer_StarsIn,Performer," = "," AND") */
            Performer_StarsIn.Name = Performer.Name
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Performer_StarsIn because Performer exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Performer_StarsIn ON Performer_StarsIn FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Performer_StarsIn */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insName char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Performer  Performer_StarsIn on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00016faf", PARENT_OWNER="", PARENT_TABLE="Performer"
    CHILD_OWNER="", CHILD_TABLE="Performer_StarsIn"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="Name" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Name)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Performer
        WHERE
          /* %JoinFKPK(inserted,Performer) */
          inserted.Name = Performer.Name
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Performer_StarsIn because Performer does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Show ON Show FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Show */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Show  Show_Reserves on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00034433", PARENT_OWNER="", PARENT_TABLE="Show"
    CHILD_OWNER="", CHILD_TABLE="Show_Reserves"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_21", FK_COLUMNS="ShowTime""FilmId" */
    IF EXISTS (
      SELECT * FROM deleted,Show_Reserves
      WHERE
        /*  %JoinFKPK(Show_Reserves,deleted," = "," AND") */
        Show_Reserves.ShowTime = deleted.ShowTime AND
        Show_Reserves.FilmId = deleted.FilmId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Show because Show_Reserves exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Film  Show on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Film"
    CHILD_OWNER="", CHILD_TABLE="Show"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="FilmId" */
    IF EXISTS (SELECT * FROM deleted,Film
      WHERE
        /* %JoinFKPK(deleted,Film," = "," AND") */
        deleted.FilmId = Film.FilmId AND
        NOT EXISTS (
          SELECT * FROM Show
          WHERE
            /* %JoinFKPK(Show,Film," = "," AND") */
            Show.FilmId = Film.FilmId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Show because Film exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Performance  Show on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Performance"
    CHILD_OWNER="", CHILD_TABLE="Show"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="ShowTime" */
    IF EXISTS (SELECT * FROM deleted,Performance
      WHERE
        /* %JoinFKPK(deleted,Performance," = "," AND") */
        deleted.ShowTime = Performance.ShowTime AND
        NOT EXISTS (
          SELECT * FROM Show
          WHERE
            /* %JoinFKPK(Show,Performance," = "," AND") */
            Show.ShowTime = Performance.ShowTime
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Show because Performance exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Show ON Show FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Show */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insShowTime char(18), 
           @insFilmId char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Show  Show_Reserves on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0003c609", PARENT_OWNER="", PARENT_TABLE="Show"
    CHILD_OWNER="", CHILD_TABLE="Show_Reserves"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_21", FK_COLUMNS="ShowTime""FilmId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ShowTime) OR
    UPDATE(FilmId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Show_Reserves
      WHERE
        /*  %JoinFKPK(Show_Reserves,deleted," = "," AND") */
        Show_Reserves.ShowTime = deleted.ShowTime AND
        Show_Reserves.FilmId = deleted.FilmId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Show because Show_Reserves exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Film  Show on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Film"
    CHILD_OWNER="", CHILD_TABLE="Show"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="FilmId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(FilmId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Film
        WHERE
          /* %JoinFKPK(inserted,Film) */
          inserted.FilmId = Film.FilmId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Show because Film does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Performance  Show on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Performance"
    CHILD_OWNER="", CHILD_TABLE="Show"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="ShowTime" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(ShowTime)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Performance
        WHERE
          /* %JoinFKPK(inserted,Performance) */
          inserted.ShowTime = Performance.ShowTime
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Show because Performance does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Show_Reserves ON Show_Reserves FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Show_Reserves */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Show  Show_Reserves on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00016a08", PARENT_OWNER="", PARENT_TABLE="Show"
    CHILD_OWNER="", CHILD_TABLE="Show_Reserves"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_21", FK_COLUMNS="ShowTime""FilmId" */
    IF EXISTS (SELECT * FROM deleted,Show
      WHERE
        /* %JoinFKPK(deleted,Show," = "," AND") */
        deleted.ShowTime = Show.ShowTime AND
        deleted.FilmId = Show.FilmId AND
        NOT EXISTS (
          SELECT * FROM Show_Reserves
          WHERE
            /* %JoinFKPK(Show_Reserves,Show," = "," AND") */
            Show_Reserves.ShowTime = Show.ShowTime AND
            Show_Reserves.FilmId = Show.FilmId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Show_Reserves because Show exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Show_Reserves ON Show_Reserves FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Show_Reserves */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insShowTime char(18), 
           @insFilmId char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Show  Show_Reserves on child update no action */
  /* ERWIN_RELATION:CHECKSUM="000182c9", PARENT_OWNER="", PARENT_TABLE="Show"
    CHILD_OWNER="", CHILD_TABLE="Show_Reserves"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_21", FK_COLUMNS="ShowTime""FilmId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(ShowTime) OR
    UPDATE(FilmId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Show
        WHERE
          /* %JoinFKPK(inserted,Show) */
          inserted.ShowTime = Show.ShowTime and
          inserted.FilmId = Show.FilmId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Show_Reserves because Show does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


