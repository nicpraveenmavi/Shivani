

CREATE procedure [dbo].[SPS_VisitingCard]
@QueryType varchar(100)=null,@Mobile bigint =null
as
begin
select m.Name, m.Mobile, m.Mem_ID, Organizationname,Meminfo_designation, Meminfo_profilepic, Meminfo_emailid,Meminfo_website, fblink, twitterlink,
 instagramlink, linkedinlink, youtubechannellink, googlemaplink, UPIQRcodeimage,Meminfo_whatsappnumber From T_Member as m
left join T_Member_Info i on i.Memid=m.Mem_ID where Mobile=@Mobile
end

