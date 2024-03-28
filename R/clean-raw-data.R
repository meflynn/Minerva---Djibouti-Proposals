
# Read in Kenya Survey and clean it


clean_survey_f <- function(data) {

  readxl::read_xlsx(data) |>
    dplyr::slice(-1) |>
    mutate(ChineseInfluence = factor(ChineseInfluence,
                                     levels = c("None", "Some", "A little", "A lot", "Don't know / haven't heard enough")),
           ChineseInfluenceExtent = factor(ChineseInfluenceExtent,
                                           levels = c("Very negative", "Somewhat negative", "Neither positive nor negative", "Somewhat positive", "Very positive", "Don't know / no opinion")),
           USInfluence = factor(InfluenceUS,
                                levels = c("None", "Some", "A little", "A lot", "Don't know / haven't heard enough")),
           USInfluenceExtent = factor(USInfluenceExtent,
                                      levels = c("Very negative", "Somewhat negative", "Neither positive nor negative", "Somewhat positive", "Very positive", "Don't know / no opinion")),
           USMilitaryPresence = factor(USMilitaryPresence,
                                       levels = c("No", "Yes", "Don't know / Decline to answer")),
           USMilitaryPresenceView = factor(USMilitaryPresenceView,
                                           levels = c("Very negative", "Somewhat negative", "Neither positive nor negative", "Somewhat positive", "Very positive", "Don't know / Decline to answer")),
           ChineseMilitaryPresence = factor(ChineseMilitaryPresence,
                                       levels = c("No", "Yes", "Don't know / Decline to answer")),
           ChineseMilitaryPresenceView = factor(ChineseMilitaryPresenceView,
                                           levels = c("Very negative", "Somewhat negative", "Neither positive nor negative", "Somewhat positive", "Very positive", "Don't know / Decline to answer")),
           USCitizenContact = factor(USCitizenContact,
                                     levels = c("No", "Yes", "Don't know / Decline to answer")),
           USCitizenContactFreq = case_when(
             is.na(USCitizenContactFreq) ~ "Never",
             USCitizenContact == "Don't know / Decline to answer" ~ "Don't know / Decline to answer",
             TRUE ~ USCitizenContactFreq
           ),
           USCitizenContactFreq = factor(USCitizenContactFreq,
                                         levels = c("Never", "Once", "A few times a year", "Monthly", "Weekly", "Daily", "Other", "Don't know / Decline to answer")),
           USCitizenContactMilitary = factor(USCitizenContactMilitary,
                                     levels = c("No", "Yes", "Don't know / Decline to answer")),
           ChineseCitizenContact = factor(ChinaCitizenContact,
                                     levels = c("No", "Yes", "Don't know / Decline to answer")),
           ChineseCitizenContactFreq = case_when(
             is.na(ChinaCitizenContactFreq) ~ "Never",
             ChineseCitizenContact == "Don't know / Decline to answer" ~ "Don't know / Decline to answer",
             TRUE ~ ChinaCitizenContactFreq
           ),
           ChineseCitizenContactFreq = factor(ChineseCitizenContactFreq,
                                         levels = c("Never", "Once", "A few times a year", "Monthly", "Weekly", "Daily", "Other", "Don't know / Decline to answer")),
           ChineseCitizenContactMilitary = factor(ChineseCitizenContactMilitary,
                                             levels = c("No", "Yes", "Don't know / Decline to answer")),
           Film = factor(Film),
           TVProgram = factor(TVProgram),
           SportsMatch = factor(SportsMatch),
           Apps = factor(Apps),
           StudyDestination = factor(StudyDestination),
           Income = factor(Income,
                           levels = c("0-77000", "77001-186000", "186001-295000", "295001-404000", "404001-515000", "Over 515000")),
           HighestEducationLevel = factor(HighestEducationLevel,
                                          levels = c("Primary", "Secondary", "Technical School", "Post-secondary certification", "College", "University", "Other", "No formal education")),
           ChineseView4cat = case_when(
             ChineseMilitaryPresenceView %in% c("Somewhat negative", "Very negative") ~ "Negative",
             ChineseMilitaryPresenceView %in% c("Somewhat positive", "Very positive") ~ "Positive",
             ChineseMilitaryPresenceView %in% c("Neither positive nor negative") ~ "Neutral",
             TRUE ~ "Don't know / Decline to answer"
           ),
           USView4cat = case_when(
             USMilitaryPresenceView %in% c("Somewhat negative", "Very negative") ~ "Negative",
             USMilitaryPresenceView %in% c("Somewhat positive", "Very positive") ~ "Positive",
             USMilitaryPresenceView %in% c("Neither positive nor negative") ~ "Neutral",
             TRUE ~ "Don't know / Decline to answer"
           ),
           Age = as.numeric(Age),
           Age_z = arm::rescale(Age),
           ADM1 = factor(ADM1),
           Gender = factor(Gender,
                           levels = c("Male", "Female", "Prefer not to say"),
                           ordered = FALSE))
}
