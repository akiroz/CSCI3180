// CSCI3180 Principles of Programming Languages
//
// --- Declaration ---
// I declare that the assignment here submitted is original except for source material explicitly
// acknowledged. I also acknowledge that I am aware of University policy and regulations on
// honesty in academic work, and of the disciplinary guidelines and procedures applicable to
// breaches of such policy and regulations, as contained in the website
// http://www.cuhk.edu.hk/policy/academichonesty/
//
// Assignment 2
// Name:
// Student ID:
// Email Addr:

import static java.lang.System.out;
import java.util.function.Consumer;

public class HAS {

    interface FoodBuyer {
        public Consumer<Integer> pay();
        default public void buyFood(String name, int cost, Consumer<Integer> pay) {
            out.printf("Buy %s and pay $%d.\n", name, cost);
            pay.accept(cost);
        }
    }

    static abstract class HospitalMember {
        public String name; public int pendingDrugs;
        public HospitalMember(String n) {name=n; pendingDrugs=0;}
        public HospitalMember(String n, int d) {name=n; pendingDrugs=d;}
        public void seeDoctor(int drugs) {
            out.printf("%s is sick! S/he sees a doctor.\n", this.toString());
        }
        public void dispense(int drugs) {
            int dispensed;
            if(drugs > pendingDrugs) {
                dispensed = pendingDrugs;
                pendingDrugs = 0;
            } else {
                dispensed = drugs;
                pendingDrugs -= drugs;
            }
            String tem = "Dispensed %d drug items, %d items still to be dispensed.\n";
            out.printf(tem, dispensed, pendingDrugs);
        }
    }

    static class Doctor extends HospitalMember implements FoodBuyer {
        public String staffId; public int salary;
        public Doctor(String id, String n) {super(n); staffId=id; salary=100_000;}
        public Consumer<Integer> pay() {return (amount)-> {
            salary -= amount;
            out.printf("%s has got HK$%d salary left.\n", toString(), salary);
        };}
        @Override public String toString() {
            return String.format("Doctor %s (%s)", name, staffId);
        }
        @Override public void seeDoctor(int drugs) {
            super.seeDoctor(drugs);
            pendingDrugs += drugs;
            out.printf("Totally %d drug items administered.\n", pendingDrugs);
        }
        public void recvSalary(int amount) {
            salary += amount;
            out.printf("%s has got HK$%d salary left.\n", toString(), salary);
        }
        public void attendClub() {out.println("Eat and drink in the Club.");}
    }

    static class Patient extends HospitalMember implements FoodBuyer {
        public String stuId; public int money;
        public Patient(String id, String n) {super(n); stuId=id; money=10_000;}
        public Consumer<Integer> pay() {return (amount)-> {
            money -= amount;
            out.printf("%s has got HK$%d left in the wallet.\n", toString(), money);
        };}
        @Override public String toString() {
            return String.format("Patient %s (%s)", name, stuId);
        }
        @Override public void seeDoctor(int drugs) {
            super.seeDoctor(drugs);
            if(drugs < 15-pendingDrugs) pendingDrugs += drugs;
            else pendingDrugs = 15;
            out.printf("Totally %d drug items administered.\n", pendingDrugs);
        }
    }

    static class Visitor implements FoodBuyer {
        public String visitorId; public int money;
        public Visitor(String id) {visitorId=id; money=1000;}
        public Consumer<Integer> pay() {return (amount)-> {
            money -= amount;
            out.printf("%s has got HK$%d left in the wallet.\n", toString(), money);
        };}
        @Override public String toString() {
            return String.format("Visitor %s", visitorId);
        }
    }

    static abstract class Entity {
        public String name;
        @Override public String toString() {
            return String.format("%s %s", name, this.getClass().getSimpleName());
        }
    }

    static class Pharmacy extends Entity {
        public Pharmacy(String n) {name=n;}
        public void dispenseDrugs(Object person, int drugs) {
            if(person instanceof HospitalMember) ((HospitalMember) person).dispense(drugs);
            else out.printf("%s is not a pharmacy user!\n", person.toString());
        }
    }

    static class Canteen extends Entity {
        public Canteen(String n) {name=n;}
        public void sellNoodle(FoodBuyer person) {
            person.buyFood("Noodle", 40, person.pay());
        }
    }

    static class Department extends Entity {
        public Department(String n) {name=n;}
        public void callPatient(Object person, int drugs) {
            if(person instanceof HospitalMember) ((HospitalMember) person).seeDoctor(drugs);
            else out.printf("%s has no rights to get see a doctor!\n", person.toString());
        }
        public void paySalary(Object person, int amount) {
            if(person instanceof Doctor) {
                String tmp = "%s pays Salary $%d to %s.\n";
                out.printf(tmp, toString(), amount, person.toString());
                ((Doctor) person).recvSalary(amount);
            } else {
                String tmp = "%s has no rights to get salary from %s!\n";
                out.printf(tmp, person.toString(), toString());
            }
        }
    }

    static class Club extends Entity{
        public Club(String n) {name=n;}
        public void holdParty(Object person) {
            if(person instanceof Doctor) ((Doctor) person).attendClub();
            else {
                String tmp = "%s has no rights to use facilities in the Club!\n";
                out.printf(tmp, person.toString());
            }
        }
    }

    public static void main(String[] args) {
        out.println("Hospital Administration System:");

        Patient alice = new Patient("p001", "Alice");
        Doctor bob = new Doctor("d001", "Bob");
        Visitor visitor = new Visitor("v001");
        Pharmacy mainPharm = new Pharmacy("Main");
        Canteen bigCtn = new Canteen("Big Big");
        Department ane = new Department("A&E");
        Club teaClub = new Club("Happy");

        Object[] people = {alice, bob, visitor};
        for(Object person: people) {
            out.printf("\n%s enters CU Hospital ...\n", person.toString());
            // A&E
            out.printf("%s enters %s.\n", person.toString(), ane.toString());
            ane.callPatient(person, 20);
            // pharmacy
            out.printf("%s enters %s.\n", person.toString(), mainPharm.toString());
            mainPharm.dispenseDrugs(person, 10);
            mainPharm.dispenseDrugs(person, 25);
            // canteen
            out.printf("%s enters %s.\n", person.toString(), bigCtn.toString());
            bigCtn.sellNoodle((FoodBuyer) person);
            // A&E again
            out.printf("%s enters %s again.\n", person.toString(), ane.toString());
            ane.paySalary(person, 10_000);
            // club
            out.printf("%s enters %s.\n", person.toString(), teaClub.toString());
            teaClub.holdParty(person);
        }
    }
}


