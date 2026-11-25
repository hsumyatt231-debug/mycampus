"""SQLAlchemy entities. Importing this package registers every table on Base.

``config.database`` imports ``Base`` from ``models.base``, which first executes
this package initializer — so all entities are present before ``create_all()``.
"""

from models.account import Account
from models.assignment import Assignment, AssignmentProgress
from models.base import Base
from models.classroom import Classroom, ClassroomMember, MembershipEvent
from models.planner import AcademicEvent, Subject, Task, TimetableEntry
from models.sync import SyncChange, SyncCursor, SyncOperation

__all__ = [
    "Account",
    "AcademicEvent",
    "Assignment",
    "AssignmentProgress",
    "Base",
    "Classroom",
    "ClassroomMember",
    "MembershipEvent",
    "Subject",
    "SyncChange",
    "SyncCursor",
    "SyncOperation",
    "Task",
    "TimetableEntry",
]
