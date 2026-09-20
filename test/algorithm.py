
import random
import copy
import json
import polars as pl
from enum import Enum


class KC(Enum):

    P1 = 1
    P2 = 2
    P3 = 3
    P4 = 4
    P5 = 5
    P6 = 6
    P7 = 7
    P8 = 8
    P9 = 9
    P10 = 10
    K = 11

class Status(Enum):

    Active = 1
    Absent = 2
    Injured = 3

    @property
    def is_in(self) -> bool:
        return self == Status.Active

class Person:

    def __init__(self,name,pos_list : list[KC] = [],status = Status.Active):
        self.name = name
        self.pos : set[KC] = set(pos_list)
        self.status : Status = status

    def pos_register(self, pos_list : list[KC]):
        for pos in pos_list:
            self.pos.add(pos)

    def renew_status(self,status : Status):
        self.status = status

    def print_profile(self):
        print(f"{self.name}: {self.status.name}, {self.pos}")

RANDOM_NAMES = [
    "Adam","Brian","Chris","Derek","Ethan","Felix","George","Henry","Ian","Jack","Kevin",
    "Liam","Mason","Nathan","Oscar","Paul","Quinn","Ryan","Steve",
    "Trevor","Victor","Wyatt","Xavier",
    "Aaron","Alan","Albert","Alex","Andrew","Anthony","Arthur","Austin","Barry","Ben",
    "Benjamin","Blake","Bradley","Brandon","Brett","Bruce","Bryan","Caleb","Carl","Carter",
    "Charles","Christian","Clark","Cody","Cole","Colin","Connor","Daniel","David","Dennis",
    "Dominic","Douglas","Dylan","Edward","Eli","Elliot","Eric","Evan","Francis","Frank",
    "Gabriel","Gary","Gavin","Gerald","Gordon","Grant","Gregory","Harold","Harrison","Harvey",
    "Hugh","Hunter","Isaac","Jacob","James","Jason","Jeffrey","Jeremy","Jerome","Joel",
    "John","Jonathan","Jordan","Joseph","Joshua","Julian","Justin","Keith","Kyle","Lance",
    "Landon","Lawrence","Leo","Leon"
]

def make_random_persons(count) -> dict:
    persons = {}
    for i in range(count):
        name = RANDOM_NAMES[i] if i < len(RANDOM_NAMES) else f"Player{i + 1}"
        positions = random.sample(list(KC), k=random.randint(1, 11))
        persons[name] = Person(name, positions)
    return persons

def available_dict(persons : dict) -> dict[KC,set[str]]:
    Available_dict = {pos : set([]) for pos in KC}
    for person in persons.values():
        for pos in person.pos:
            Available_dict[pos].add(person.name)
    return Available_dict

def substitute_dict(main_members : dict[KC,set[str]], available_dict : dict[KC,set[str]]) -> dict[KC,set[str]]:
    Substitute_dict = copy.deepcopy(available_dict)
    for pos, member_set in main_members.items():
        for pos_ in KC:
            Substitute_dict[pos_] -= member_set
    return Substitute_dict

def print_availabe_dict(available_dict, pos_list : list[KC] = []):
    if pos_list == []:
        pos_list = [pos for pos in KC]
    pos_list = set(pos_list)
    print("#==============================================")
    for pos, available_persons in available_dict.items():
        if pos in pos_list:
            print(f"{pos.name}:({len(available_persons)}) {available_persons}")
    print("#==============================================")

def save(persons : dict[str,Person], main_members, sub_members, fixed_dict : dict[KC,str]):
    output = {
        "Persons" : {},
        "main" : [],
        "sub" : [],
        "fix" : {},
    }
    for i in range(len(main_members)):
        output["main"].append(main_members[i])
        output["sub"].append(sub_members[i])
        if KC(i+1) in fixed_dict:
            output["fix"][i+1] = fixed_dict[KC(i+1)]
    for name, person in persons.items():
        output["Persons"][name] = {
            "status" : person.status.value,
            "pos" : [pos.value for pos in person.pos]
        }
    with open("data.json", "w", encoding="utf-8") as f:
        json.dump(
            output,
            f,
            indent=2
        )

def load():
    with open("data.json", "r", encoding="utf-8") as f:
        data = json.load(f)
    input_data = {
        "Persons" : {},
        "main" : data["main"],
        "sub" : data["sub"],
        "fix" : {},
    }
    for name,person in data["Persons"].items():
        # person : {status : int, pos : list[int]}
        input_data["Persons"][name] = Person(name,[KC(id) for id in person["pos"]],Status(person["status"]))
    for i in range(1,len(KC)+1):
        if str(i) in data["fix"]:
            input_data["fix"][KC(i)] = data["fix"][str(i)]
    return input_data

def get_actual_members(persons : dict[str,Person], available_dict : dict[KC,set[str]], fixed_dict : dict[KC,str] = []) -> pl.DataFrame:
    current_lineup = [fixed_dict[pos] if pos in fixed_dict else "" for pos in KC]
    if fixed_dict == []:
        assigned : set[str] = set([])
        unassigned : set[KC] = set([pos for pos in KC])
    else:
        assigned : set[str] = set(list(fixed_dict.values())) # 既に選んでいるメンバー
        unassigned : set[KC] = set([pos for pos in KC if not pos in fixed_dict]) # 未選択のポジション

    candidate_members = [] # 考えられるメンバーの組

    def DFS(current_lineup : list[str], assigned : set[str], unassigned : set[KC]):
        if len(unassigned) == 0:
            candidate_members.append(current_lineup)
            return
        for pos in unassigned: # 未選択のポジションでfor 文を回す
            for possible_member in available_dict[pos]: # そのポジションに携われるメンバー
                if not possible_member in assigned: # すでに選ばれているメンバーでないから選択できる
                    next_lineup = current_lineup.copy()
                    new_assigned = assigned.copy()
                    new_assigned.add(possible_member)
                    new_unassigned = unassigned.copy()
                    new_unassigned.remove(pos)
                    next_lineup[pos.value-1] = possible_member
                    DFS(next_lineup,new_assigned,new_unassigned)

    DFS(current_lineup,assigned,unassigned)
    
    return pl.DataFrame(
        data=candidate_members,
        schema=[KC(i).name for i in range(1,len(KC)+1)]
    )

def initialize():
    for pos in KC:
        print_availabe_dict(Substitute_dict,[pos])
        print(main_members)
        while True:
            name = input(f"Who is {pos.name} as main?\n")
            if name in Substitute_dict[pos]:
                break
        main_members.append(name)
        for pos_ in KC:
            if name in Substitute_dict[pos_]:
                Substitute_dict[pos_].remove(name)

    print_availabe_dict(Substitute_dict,[pos])
    print(main_members) 

    for pos in KC:
        print_availabe_dict(Substitute_dict,[pos])
        print(sub_members)
        while True:
            name = input(f"Who is {pos.name} as sub?\n")
            if name in Substitute_dict[pos] or name == "":
                break
        sub_members.append(name)
        if name != "":
            for pos_ in KC:
                if name in Substitute_dict[pos_]:
                    Substitute_dict[pos_].remove(name)

    print_availabe_dict(Substitute_dict,[pos])
    print(sub_members)

    # save(Persons,main_members,sub_members)

def initS(available_dict : dict[KC,set[str]]) -> list[str]:
    sub_members = []
    for pos in KC:
        while True:
            name = input(f"Who is {pos.name} as sub?\n")
            if name in available_dict[pos]:
                break
        sub_members.append(name)
    return sub_members

Persons = {}
Availabe_dict = {}
Substitute_dict = {}
main_members = []
sub_members = []
fixed_dict = {}
candidate_members = []

while True:
    order = input(
        "initS : initialize sub members, a : available dict, m : main members, sub : sub members, status : print status of main members, r : renew status, act : get actual members, save : save, l : load, e : exit\n"
        )

    if order == "a":
        print("Available")
        print_availabe_dict(Availabe_dict)
        print("Substitute")
        print_availabe_dict(Substitute_dict)
    elif order == "m":
        print(main_members)
    elif order == "sub":
        print(sub_members)
    elif order == "r":
        while True:
            name = input("who is renewed?\n")
            if name in Persons:
                break
            else:
                print("No such person here")
        Persons[name].print_profile()
        while True:
            new_status_id = input("1:Active,2:Absent,3:Injured\n")
            if new_status_id in set(["1","2","3"]):
                break
            else:
                print("Wrong input")
        Persons[name].renew_status(Status(int(new_status_id)))
        Persons[name].print_profile()
    elif order == "initS":
        sub_members = initS(available_dict=Availabe_dict)
        print(sub_members)
    elif order == "status":
        print([name if Persons[name].status.value == 1 else "X" for name in main_members])
    elif order == "fix":
        print("Enter fixed members")
        chosed_members : set[str] = set([])
        for pos in KC:
            is_chosed = False
            while True:
                name = input(f"Who is in {pos}?\n")
                if name in Availabe_dict[pos] and not name in chosed_members:
                    is_chosed = True
                    break
                elif name == "":
                    break
                else:
                    print("try agin.")
            if is_chosed:
                fixed_dict[pos] = name
        print("member chosen")
        print(fixed_dict)
    elif order == "act":
        candidate_members = get_actual_members(persons=Persons,available_dict=Availabe_dict,fixed_dict=fixed_dict)
        print(candidate_members)
    elif order == "save":
        save(persons=Persons, main_members=main_members,sub_members=sub_members, fixed_dict=fixed_dict)
    elif order == "l":
        input_data = load()
        Persons = input_data["Persons"]
        main_members = input_data["main"]
        sub_members = input_data["sub"]
        fixed_dict = input_data["fix"]
        Availabe_dict = available_dict(persons=Persons)
        Substitute_dict = substitute_dict(main_members={KC(i+1) : set([main_members[i],sub_members[i]]) for i in range(len(KC))},available_dict=Availabe_dict)
    elif order == "e":
        break
    else:
        print("unsupported order!")
        continue
    