#ifndef TASKMODEL_H
#define TASKMODEL_H

#include <QAbstractListModel>
#include <QtQml>
#include <vector>

struct Task {
    QString name;
    bool isCompleted;
};

class TaskModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit TaskModel(QObject *parent = nullptr);

    enum TaskRoles {
        TaskNameRole = Qt::UserRole + 1,
        TaskCompletedRole
    };

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addTask(const QString &taskName);
    Q_INVOKABLE void removeTask(int index);

    Q_INVOKABLE void toggleTask(int index);

private:
    std::vector<Task> m_tasks;
};

#endif // TASKMODEL_H
