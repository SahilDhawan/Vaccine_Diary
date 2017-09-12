//
//  VaccinationList.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 07/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation
import UIKit

class VaccinationList : NSObject
{
    var VaccinationSchedule : [Vaccine] = []
    func setVaccineList() {
        let currentDate = Date(timeIntervalSinceNow: 0)
        let birthBool = currentDate > UserDetails.userBirthDate
        let sixWeeksBool = currentDate > UserDetails.VaccinationDates.sixWeeksDate!
        let tenWeeksBool = currentDate > UserDetails.VaccinationDates.tenWeeksDate!
        let fourteenWeeksBool = currentDate > UserDetails.VaccinationDates.fourteenWeeksDate!
        let sixMonthsBool = currentDate > UserDetails.VaccinationDates.sixMonthsDate!
        let nineMonthsBool = currentDate > UserDetails.VaccinationDates.nineMonthsDate!
        let oneYearBool = currentDate > UserDetails.VaccinationDates.oneYearDate!
        let fifteenMonthBool = currentDate > UserDetails.VaccinationDates.fifteenMonthsDate!
        let eighteenMonthBool = currentDate > UserDetails.VaccinationDates.eighteenMonthsDate!
        let twoYearBool = currentDate > UserDetails.VaccinationDates.twoYearDate!
        let sixYearBool = currentDate > UserDetails.VaccinationDates.sixYearDate!
        let twelveYearBool = currentDate > UserDetails.VaccinationDates.twelveYearDate!
        
        //birth
        VaccinationSchedule.append(Vaccine("BCG",UserDetails.userBirthDate,birthBool , "Bacillus Calmette–Guérin (BCG) vaccine is a vaccine primarily used against tuberculosis. In countries where tuberculosis is common, one dose is recommended in healthy babies as close to the time of birth as possible. Babies with HIV/AIDS should not be vaccinated. In areas where tuberculosis is not common, only children at high risk are typically immunized, while suspected cases of tuberculosis are individually tested for and treated. Adults who do not have tuberculosis and have not been previously immunized but are frequently exposed to drug-resistant tuberculosis may be immunized as well. The vaccine is also often used as part of the treatment of bladder cancer."))
        
        VaccinationSchedule.append(Vaccine("OPV 0",UserDetails.userBirthDate,birthBool , "Polio vaccines are vaccines used to prevent poliomyelitis (polio). There are two types: one that uses inactivated poliovirus and is given by injection (IPV), and one that uses weakened poliovirus and is given by mouth (OPV). The World Health Organization recommends all children be fully vaccinated against polio. The two vaccines have eliminated polio from most of the world, and reduced the number of cases each year from an estimated 350,000 in 1988 to 37 in 2016."))
        
        VaccinationSchedule.append(Vaccine("Hep-B 1",UserDetails.userBirthDate,birthBool , "Hepatitis B vaccine is a vaccine that prevents hepatitis B. The first dose is recommended within 24 hours of birth with either two or three more doses given after that. This includes those with poor immune function such as from HIV/AIDS and those born premature. In healthy people routine immunization results in more than 95% of people being protected."))
        
        //SixWeeks
        VaccinationSchedule.append(Vaccine("DTwP-1",UserDetails.VaccinationDates.sixWeeksDate!,sixWeeksBool , "DPT (also DTP and DTwP) refers to a class of combination vaccines against three infectious diseases in humans: diphtheria, pertussis (whooping cough), and tetanus. The vaccine components include diphtheria and tetanus toxoids and killed whole cells of the organism that cause pertussis (wP).\nDTaP and Tdap refer to similar combination vaccines in which the component with lower case \"a\" is acellular.\nAlso available is the DT or TD vaccine, which lacks the pertussis component. The Tdap vaccine is currently recommended by the CDC and covers tetanus, diphtheria and pertussis (CDC Vaccines, 2013)."))
        
        VaccinationSchedule.append(Vaccine("IPV 1",UserDetails.VaccinationDates.sixWeeksDate!,sixWeeksBool , "Inactivated polio vaccine (IPV) was developed in 1955 by Dr Jonas Salk. Also called the Salk vaccine IPV consists of inactivated (killed) poliovirus strains of all three poliovirus types. IPV is given by intramuscular or intradermal injection and needs to be administered by a trained health worker. IVP produces antibodies in the blood to all three types of poliovirus. In the event of infection, these antibodies prevent the spread of the virus to the central nervous system and protect against paralysis."))
        
        VaccinationSchedule.append(Vaccine("Hep-B 2",UserDetails.VaccinationDates.sixWeeksDate!,sixWeeksBool , "Hepatitis B vaccine is a vaccine that prevents hepatitis B. The first dose is recommended within 24 hours of birth with either two or three more doses given after that. This includes those with poor immune function such as from HIV/AIDS and those born premature. In healthy people routine immunization results in more than 95% of people being protected."))
        
        VaccinationSchedule.append(Vaccine("Hib 1",UserDetails.VaccinationDates.sixWeeksDate!,sixWeeksBool ,"The Haemophilus influenzae type B vaccine, often called Hib vaccine, is a vaccine used to prevent Haemophilus influenzae type b (Hib) infection.[1] In countries that include it as a routine vaccine, rates of severe Hib infections have decreased more than 90%. It has therefore resulted in a decrease in the rate of meningitis, pneumonia, and epiglottitis.\nIt is recommended by both the World Health Organization and Centers for Disease Control and Prevention. Two or three doses should be given before six months of age. In the United States a fourth dose is recommended between 12 and 15 months of age. The first dose is recommended around six weeks of age with at least four weeks between doses. If only two doses are used, another dose later in life is recommended. It is given by injection into a muscle."))
        
        VaccinationSchedule.append(Vaccine("Rotavirus 1",UserDetails.VaccinationDates.sixWeeksDate!,sixWeeksBool , "Rotavirus is the most common cause of diarrhoeal disease among infants and young children. It is a genus of double-stranded RNA viruses in the family Reoviridae. Nearly every child in the world is infected with rotavirus at least once by the age of five. Immunity develops with each infection, so subsequent infections are less severe; adults are rarely affected. There are eight species of this virus, referred to as A, B, C, D, E, F, G and H. Rotavirus A, the most common species, causes more than 90% of rotavirus infections in humans."))
        
        VaccinationSchedule.append(Vaccine("PCV 1",UserDetails.VaccinationDates.sixWeeksDate!,sixWeeksBool , "Pneumococcal conjugate vaccine (PCV) is a pneumococcal vaccine and a conjugate vaccine used to protect infants, young children, and adults against disease caused by the bacterium Streptococcus pneumoniae (the pneumococcus). There are currently three types of PCV available on the global market, which go by the brand names: Prevnar (called Prevenar in some countries), Synflorix and Prevnar 13."))
        
        //TenWeeks
        VaccinationSchedule.append(Vaccine("DTwP 2",UserDetails.VaccinationDates.tenWeeksDate!,tenWeeksBool, "DPT (also DTP and DTwP) refers to a class of combination vaccines against three infectious diseases in humans: diphtheria, pertussis (whooping cough), and tetanus. The vaccine components include diphtheria and tetanus toxoids and killed whole cells of the organism that cause pertussis (wP).\nDTaP and Tdap refer to similar combination vaccines in which the component with lower case \"a\" is acellular.\nAlso available is the DT or TD vaccine, which lacks the pertussis component. The Tdap vaccine is currently recommended by the CDC and covers tetanus, diphtheria and pertussis (CDC Vaccines, 2013)."))
        
        VaccinationSchedule.append(Vaccine("IPV 2",UserDetails.VaccinationDates.tenWeeksDate!,tenWeeksBool , "Inactivated polio vaccine (IPV) was developed in 1955 by Dr Jonas Salk. Also called the Salk vaccine IPV consists of inactivated (killed) poliovirus strains of all three poliovirus types. IPV is given by intramuscular or intradermal injection and needs to be administered by a trained health worker. IVP produces antibodies in the blood to all three types of poliovirus. In the event of infection, these antibodies prevent the spread of the virus to the central nervous system and protect against paralysis."))
            
        VaccinationSchedule.append(Vaccine("Hib 2",UserDetails.VaccinationDates.tenWeeksDate!,tenWeeksBool,"The Haemophilus influenzae type B vaccine, often called Hib vaccine, is a vaccine used to prevent Haemophilus influenzae type b (Hib) infection.[1] In countries that include it as a routine vaccine, rates of severe Hib infections have decreased more than 90%. It has therefore resulted in a decrease in the rate of meningitis, pneumonia, and epiglottitis.\nIt is recommended by both the World Health Organization and Centers for Disease Control and Prevention. Two or three doses should be given before six months of age. In the United States a fourth dose is recommended between 12 and 15 months of age. The first dose is recommended around six weeks of age with at least four weeks between doses. If only two doses are used, another dose later in life is recommended. It is given by injection into a muscle."))
        
        VaccinationSchedule.append(Vaccine("Rotavirus 2",UserDetails.VaccinationDates.tenWeeksDate!,tenWeeksBool , "Rotavirus is the most common cause of diarrhoeal disease among infants and young children. It is a genus of double-stranded RNA viruses in the family Reoviridae. Nearly every child in the world is infected with rotavirus at least once by the age of five. Immunity develops with each infection, so subsequent infections are less severe; adults are rarely affected. There are eight species of this virus, referred to as A, B, C, D, E, F, G and H. Rotavirus A, the most common species, causes more than 90% of rotavirus infections in humans."
        ))
        
        VaccinationSchedule.append(Vaccine("PCV 2",UserDetails.VaccinationDates.tenWeeksDate!,tenWeeksBool, "Pneumococcal conjugate vaccine (PCV) is a pneumococcal vaccine and a conjugate vaccine used to protect infants, young children, and adults against disease caused by the bacterium Streptococcus pneumoniae (the pneumococcus). There are currently three types of PCV available on the global market, which go by the brand names: Prevnar (called Prevenar in some countries), Synflorix and Prevnar 13."))
        
        //FourteenWeeks
        VaccinationSchedule.append(Vaccine("DTwP 3",UserDetails.VaccinationDates.fourteenWeeksDate!,fourteenWeeksBool, "DPT (also DTP and DTwP) refers to a class of combination vaccines against three infectious diseases in humans: diphtheria, pertussis (whooping cough), and tetanus. The vaccine components include diphtheria and tetanus toxoids and killed whole cells of the organism that cause pertussis (wP).\nDTaP and Tdap refer to similar combination vaccines in which the component with lower case \"a\" is acellular.\nAlso available is the DT or TD vaccine, which lacks the pertussis component. The Tdap vaccine is currently recommended by the CDC and covers tetanus, diphtheria and pertussis (CDC Vaccines, 2013)."))
        
        VaccinationSchedule.append(Vaccine("IPV 3",UserDetails.VaccinationDates.fourteenWeeksDate!,fourteenWeeksBool , "Inactivated polio vaccine (IPV) was developed in 1955 by Dr Jonas Salk. Also called the Salk vaccine IPV consists of inactivated (killed) poliovirus strains of all three poliovirus types. IPV is given by intramuscular or intradermal injection and needs to be administered by a trained health worker. IVP produces antibodies in the blood to all three types of poliovirus. In the event of infection, these antibodies prevent the spread of the virus to the central nervous system and protect against paralysis."))
        
        VaccinationSchedule.append(Vaccine("Hib 3",UserDetails.VaccinationDates.fourteenWeeksDate!,fourteenWeeksBool,"The Haemophilus influenzae type B vaccine, often called Hib vaccine, is a vaccine used to prevent Haemophilus influenzae type b (Hib) infection. In countries that include it as a routine vaccine, rates of severe Hib infections have decreased more than 90%. It has therefore resulted in a decrease in the rate of meningitis, pneumonia, and epiglottitis.\nIt is recommended by both the World Health Organization and Centers for Disease Control and Prevention. Two or three doses should be given before six months of age. In the United States a fourth dose is recommended between 12 and 15 months of age. The first dose is recommended around six weeks of age with at least four weeks between doses. If only two doses are used, another dose later in life is recommended. It is given by injection into a muscle."))
        
        VaccinationSchedule.append(Vaccine("Rotavirus 3",UserDetails.VaccinationDates.fourteenWeeksDate!,fourteenWeeksBool , "Rotavirus is the most common cause of diarrhoeal disease among infants and young children. It is a genus of double-stranded RNA viruses in the family Reoviridae. Nearly every child in the world is infected with rotavirus at least once by the age of five. Immunity develops with each infection, so subsequent infections are less severe; adults are rarely affected. There are eight species of this virus, referred to as A, B, C, D, E, F, G and H. Rotavirus A, the most common species, causes more than 90% of rotavirus infections in humans."))
        
        VaccinationSchedule.append(Vaccine("PCV 3",UserDetails.VaccinationDates.fourteenWeeksDate!,fourteenWeeksBool, "Pneumococcal conjugate vaccine (PCV) is a pneumococcal vaccine and a conjugate vaccine used to protect infants, young children, and adults against disease caused by the bacterium Streptococcus pneumoniae (the pneumococcus). There are currently three types of PCV available on the global market, which go by the brand names: Prevnar (called Prevenar in some countries), Synflorix and Prevnar 13."))
        
        //SixMonths
        VaccinationSchedule.append(Vaccine("OPV 1",UserDetails.VaccinationDates.sixMonthsDate!,sixMonthsBool, "Polio vaccines are vaccines used to prevent poliomyelitis (polio). There are two types: one that uses inactivated poliovirus and is given by injection (IPV), and one that uses weakened poliovirus and is given by mouth (OPV). The World Health Organization recommends all children be fully vaccinated against polio. The two vaccines have eliminated polio from most of the world, and reduced the number of cases each year from an estimated 350,000 in 1988 to 37 in 2016."))
        
        VaccinationSchedule.append(Vaccine("Hep-B 3",UserDetails.VaccinationDates.sixMonthsDate!,sixMonthsBool , "Hepatitis B vaccine is a vaccine that prevents hepatitis B. The first dose is recommended within 24 hours of birth with either two or three more doses given after that. This includes those with poor immune function such as from HIV/AIDS and those born premature. In healthy people routine immunization results in more than 95% of people being protected."))
        
        //NineMonths
        VaccinationSchedule.append(Vaccine("OPV 2",UserDetails.VaccinationDates.nineMonthsDate!,nineMonthsBool ,"Polio vaccines are vaccines used to prevent poliomyelitis (polio). There are two types: one that uses inactivated poliovirus and is given by injection (IPV), and one that uses weakened poliovirus and is given by mouth (OPV). The World Health Organization recommends all children be fully vaccinated against polio. The two vaccines have eliminated polio from most of the world, and reduced the number of cases each year from an estimated 350,000 in 1988 to 37 in 2016."))
        
        VaccinationSchedule.append(Vaccine("MMR-1",UserDetails.VaccinationDates.nineMonthsDate!,nineMonthsBool , "The MMR vaccine (also known as the MPR vaccine after the Latin names of the diseases) is an immunization vaccine against measles, mumps, and rubella (German measles). It is a mixture of live attenuated viruses of the three diseases, administered via injection. It was first developed by Maurice Hilleman while at Merck.\nA licensed vaccine to prevent measles first became available in 1963, and an improved one in 1968. Vaccines for mumps and rubella became available in 1967 and 1969, respectively. The three vaccines (for mumps, measles, and rubella) were combined in 1971 to become the measles-mumps-rubella (MMR) vaccine."))
        
        //OneYear
        VaccinationSchedule.append(Vaccine("Typhoid Conjugate",UserDetails.VaccinationDates.oneYearDate!,oneYearBool , "Currently, two typhoid conjugate vaccines, Typbar-TCV and PedaTyph® available in Indian market; either can be used. An interval of at least 4 weeks with the MMR vaccine should be maintained while administering this vaccine"))
        
        VaccinationSchedule.append(Vaccine("Hep-A 1",UserDetails.VaccinationDates.oneYearDate!,oneYearBool , "Hepatitis A vaccine is a vaccine that prevents hepatitis A. It is effective in around 95% of cases and lasts for at least fifteen years and possibly a person's entire life. If given, two doses are recommended beginning after the age of one. It is given by injection into a muscle.\nThe World Health Organization (WHO) recommends universal vaccination in areas where the diseases is moderately common. Where the disease is very common, widespread vaccination is not recommended as all people typically develop immunity through infection when a child. The Center for Disease Control and Prevention (CDC) recommends vaccinating adults who are at high risk and all children."))
        
        //FifteenMonths
        VaccinationSchedule.append(Vaccine("MMR 2",UserDetails.VaccinationDates.fifteenMonthsDate!,fifteenMonthBool, "The MMR vaccine (also known as the MPR vaccine after the Latin names of the diseases) is an immunization vaccine against measles, mumps, and rubella (German measles). It is a mixture of live attenuated viruses of the three diseases, administered via injection. It was first developed by Maurice Hilleman while at Merck.\nA licensed vaccine to prevent measles first became available in 1963, and an improved one in 1968. Vaccines for mumps and rubella became available in 1967 and 1969, respectively. The three vaccines (for mumps, measles, and rubella) were combined in 1971 to become the measles-mumps-rubella (MMR) vaccine."))
        
        VaccinationSchedule.append(Vaccine("Varicella 1",UserDetails.VaccinationDates.fifteenMonthsDate!,fifteenMonthBool , "Varicella vaccine, also known as chickenpox vaccine, is a vaccine that protects against chickenpox. One dose of vaccine prevents 95% of moderate disease and 100% of severe disease. Two doses of vaccine are more effective than one.[2] If given to those who are not immune within five days of exposure to chickenpox it prevents most cases of disease. Vaccinating a large portion of the population also protects those who are not vaccinated. It is given by injection just under the skin."))
        
        VaccinationSchedule.append(Vaccine("PCV booster",UserDetails.VaccinationDates.fifteenMonthsDate!,fifteenMonthBool, "Pneumococcal conjugate vaccine (PCV) is a pneumococcal vaccine and a conjugate vaccine used to protect infants, young children, and adults against disease caused by the bacterium Streptococcus pneumoniae (the pneumococcus). There are currently three types of PCV available on the global market, which go by the brand names: Prevnar (called Prevenar in some countries), Synflorix and Prevnar 13."))
        
        //EighteenMonths
        VaccinationSchedule.append(Vaccine("DTwP B1/DTaP B1",UserDetails.VaccinationDates.eighteenMonthsDate!,eighteenMonthBool, "DPT (also DTP and DTwP) refers to a class of combination vaccines against three infectious diseases in humans: diphtheria, pertussis (whooping cough), and tetanus. The vaccine components include diphtheria and tetanus toxoids and killed whole cells of the organism that cause pertussis (wP).\nDTaP and Tdap refer to similar combination vaccines in which the component with lower case \"a\" is acellular.\nAlso available is the DT or TD vaccine, which lacks the pertussis component. The Tdap vaccine is currently recommended by the CDC and covers tetanus, diphtheria and pertussis (CDC Vaccines, 2013)."))
        
        VaccinationSchedule.append(Vaccine("IPV B1",UserDetails.VaccinationDates.eighteenMonthsDate!,eighteenMonthBool , "Inactivated polio vaccine (IPV) was developed in 1955 by Dr Jonas Salk. Also called the Salk vaccine IPV consists of inactivated (killed) poliovirus strains of all three poliovirus types. IPV is given by intramuscular or intradermal injection and needs to be administered by a trained health worker. IVP produces antibodies in the blood to all three types of poliovirus. In the event of infection, these antibodies prevent the spread of the virus to the central nervous system and protect against paralysis."))
        
        VaccinationSchedule.append(Vaccine("Hib B1",UserDetails.VaccinationDates.eighteenMonthsDate!,eighteenMonthBool,"The Haemophilus influenzae type B vaccine, often called Hib vaccine, is a vaccine used to prevent Haemophilus influenzae type b (Hib) infection.[1] In countries that include it as a routine vaccine, rates of severe Hib infections have decreased more than 90%. It has therefore resulted in a decrease in the rate of meningitis, pneumonia, and epiglottitis.\nIt is recommended by both the World Health Organization and Centers for Disease Control and Prevention. Two or three doses should be given before six months of age. In the United States a fourth dose is recommended between 12 and 15 months of age. The first dose is recommended around six weeks of age with at least four weeks between doses. If only two doses are used, another dose later in life is recommended. It is given by injection into a muscle."))
        
        VaccinationSchedule.append(Vaccine("Hep-A 2",UserDetails.VaccinationDates.eighteenMonthsDate!,eighteenMonthBool, "Hepatitis A vaccine is a vaccine that prevents hepatitis A. It is effective in around 95% of cases and lasts for at least fifteen years and possibly a person's entire life. If given, two doses are recommended beginning after the age of one. It is given by injection into a muscle.\nThe World Health Organization (WHO) recommends universal vaccination in areas where the diseases is moderately common. Where the disease is very common, widespread vaccination is not recommended as all people typically develop immunity through infection when a child. The Center for Disease Control and Prevention (CDC) recommends vaccinating adults who are at high risk and all children."))
        
        //TwoYears
        VaccinationSchedule.append(Vaccine("Booster of Typhoid",UserDetails.VaccinationDates.twoYearDate!,twoYearBool , "A booster dose of Typhoid conjugate vaccine (TCV), if primary dose is given at 9-12 months. A dose of Typhoid Vi-polysaccharide (Vi-PS) vaccine can be given if conjugate vaccine is not available or feasible. Revaccination every 3 years with Vi-polysaccharide vaccine. Typhoid conjugate vaccine should be preferred over Vi- PS vaccine"))
        
        VaccinationSchedule.append(Vaccine("Conjugate Vaccine",UserDetails.VaccinationDates.twoYearDate!,twoYearBool , "A booster dose of Typhoid conjugate vaccine (TCV), if primary dose is given at 9-12 months. A dose of Typhoid Vi-polysaccharide (Vi-PS) vaccine can be given if conjugate vaccine is not available or feasible. Revaccination every 3 years with Vi-polysaccharide vaccine. Typhoid conjugate vaccine should be preferred over Vi- PS vaccine"))
        
        //SixYears
        VaccinationSchedule.append(Vaccine("DTwP B2/DTaP B2",UserDetails.VaccinationDates.sixYearDate!,sixYearBool, "DPT (also DTP and DTwP) refers to a class of combination vaccines against three infectious diseases in humans: diphtheria, pertussis (whooping cough), and tetanus. The vaccine components include diphtheria and tetanus toxoids and killed whole cells of the organism that cause pertussis (wP).\nDTaP and Tdap refer to similar combination vaccines in which the component with lower case \"a\" is acellular.\nAlso available is the DT or TD vaccine, which lacks the pertussis component. The Tdap vaccine is currently recommended by the CDC and covers tetanus, diphtheria and pertussis (CDC Vaccines, 2013)."))
        
        VaccinationSchedule.append(Vaccine("OPV 3",UserDetails.VaccinationDates.sixYearDate!,sixYearBool ,"Polio vaccines are vaccines used to prevent poliomyelitis (polio). There are two types: one that uses inactivated poliovirus and is given by injection (IPV), and one that uses weakened poliovirus and is given by mouth (OPV). The World Health Organization recommends all children be fully vaccinated against polio. The two vaccines have eliminated polio from most of the world, and reduced the number of cases each year from an estimated 350,000 in 1988 to 37 in 2016."))
        
        VaccinationSchedule.append(Vaccine("Varicella 2",UserDetails.VaccinationDates.sixYearDate!,sixYearBool , "Varicella vaccine, also known as chickenpox vaccine, is a vaccine that protects against chickenpox. One dose of vaccine prevents 95% of moderate disease and 100% of severe disease. Two doses of vaccine are more effective than one. If given to those who are not immune within five days of exposure to chickenpox it prevents most cases of disease. Vaccinating a large portion of the population also protects those who are not vaccinated. It is given by injection just under the skin."))
        
        VaccinationSchedule.append(Vaccine("MMR 3",UserDetails.VaccinationDates.sixYearDate!,sixYearBool, "The MMR vaccine (also known as the MPR vaccine after the Latin names of the diseases) is an immunization vaccine against measles, mumps, and rubella (German measles). It is a mixture of live attenuated viruses of the three diseases, administered via injection. It was first developed by Maurice Hilleman while at Merck.\nA licensed vaccine to prevent measles first became available in 1963, and an improved one in 1968. Vaccines for mumps and rubella became available in 1967 and 1969, respectively. The three vaccines (for mumps, measles, and rubella) were combined in 1971 to become the measles-mumps-rubella (MMR) vaccine."))
        
        //TwelveYears
        VaccinationSchedule.append(Vaccine("Tdap/Td",UserDetails.VaccinationDates.twelveYearDate!,twelveYearBool , "Tdap vaccine can protect adolescents and adults from tetanus, diphtheria, and pertussis. One dose of Tdap is routinely given at age 11 or 12.  People who did not get Tdap at that age should get it as soon as possible.Tdap is especially important for health care professionals and anyone having close contact with a baby younger than 12 months.\nPregnant women should get a dose of Tdap during every pregnancy, to protect the newborn from pertussis.  Infants are most at risk for severe, life-threatening complications from pertussis."))
        
        VaccinationSchedule.append(Vaccine("HPV",UserDetails.VaccinationDates.twelveYearDate!,twelveYearBool , "Human papilloma virus (HPV) vaccines are vaccines that prevent infection by certain types of human papillomavirus. Available vaccines protect against either two, four, or nine types of HPV. All vaccines protect against at least HPV type 16 and 18 that cause the greatest risk of cervical cancer. It is estimated that they may prevent 70% of cervical cancer, 80% of anal cancer, 60% of vaginal cancer, 40% of vulvar cancer, and possibly some mouth cancer. They additionally prevent some genital warts with the vaccines against 4 and 9 HPV types providing greater protection."))
        
        setNotifications()
    }
    
    func setNotifications()
    {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        for Vaccine in VaccinationSchedule
        {
            delegate.scheduleNotifications(Vaccine.vaccineDate, Vaccine.vaccineName)
        }
        
    }
    
    func getTableSize() ->Int
    {
        let tableSize = VaccinationSchedule.count
        return tableSize
    }
    
    func getVaccineDetails() -> [Vaccine]
    {
        return VaccinationSchedule
    }
}
