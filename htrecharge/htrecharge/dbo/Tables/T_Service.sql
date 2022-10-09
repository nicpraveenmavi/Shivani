CREATE TABLE [dbo].[T_Service] (
    [service_id]           BIGINT           IDENTITY (1, 1) NOT NULL,
    [service_memid]        INT              NOT NULL,
    [service_cateid]       INT              NOT NULL,
    [Booking_fee]          DECIMAL (18, 3)  NULL,
    [Specialisation1]      VARCHAR (500)    NULL,
    [Specialisation2]      VARCHAR (500)    NULL,
    [Specialisation3]      VARCHAR (500)    NULL,
    [Specialisation4]      VARCHAR (500)    NULL,
    [Specialisation5]      VARCHAR (500)    NULL,
    [servicelocationphoto] VARCHAR (250)    NULL,
    [Creationdate]         DATETIME         NULL,
    [IP]                   VARCHAR (50)     NULL,
    [Latitude]             DECIMAL (18, 16) NULL,
    [Longitude]            DECIMAL (18, 16) NULL,
    [LocationAddress]      VARCHAR (500)    NULL,
    CONSTRAINT [PK_T_Service] PRIMARY KEY CLUSTERED ([service_id] ASC)
);

