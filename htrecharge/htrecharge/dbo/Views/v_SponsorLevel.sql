CREATE VIEW [dbo].[v_SponsorLevel]
AS
	Select * From (
		Select 1 as LevelNo, 'First Level' as LevelName
		Union
		Select 2 as LevelNo, 'Second Level' as LevelName
		Union
		Select 3 as LevelNo, 'Third Level' as LevelName
		Union
		Select 4 as LevelNo, 'Fourth Level' as LevelName
		Union
		Select 5 as LevelNo, 'Fifth Level' as LevelName
		Union
		Select 6 as LevelNo, 'Sixth Level' as LevelName
		Union
		Select 7 as LevelNo, 'Seventh Level' as LevelName
	) as v
